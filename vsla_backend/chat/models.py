from django.db import models
from vsla_backend.users.models import UserProfile


class HealthWorkerMessage(models.Model):
    """Chat messages between health workers and youth"""
    
    sender = models.ForeignKey(
        UserProfile, 
        on_delete=models.CASCADE, 
        related_name='sent_messages'
    )
    receiver = models.ForeignKey(
        UserProfile, 
        on_delete=models.CASCADE, 
        related_name='received_messages'
    )
    
    # Message content
    message = models.TextField()
    message_type = models.CharField(
        max_length=20,
        choices=[
            ('text', 'Text'),
            ('image', 'Image'),
            ('file', 'File'),
            ('voice', 'Voice'),
            ('video', 'Video'),
        ],
        default='text'
    )
    
    # Message status
    is_read = models.BooleanField(default=False)
    is_delivered = models.BooleanField(default=False)
    is_edited = models.BooleanField(default=False)
    
    # Timestamps
    timestamp = models.DateTimeField(auto_now_add=True)
    read_at = models.DateTimeField(null=True, blank=True)
    edited_at = models.DateTimeField(null=True, blank=True)
    
    # Additional metadata
    reply_to = models.ForeignKey(
        'self', 
        on_delete=models.SET_NULL, 
        null=True, 
        blank=True, 
        related_name='replies'
    )
    attachments = models.JSONField(default=list, help_text="List of file attachments")
    
    class Meta:
        verbose_name = 'Health Worker Message'
        verbose_name_plural = 'Health Worker Messages'
        ordering = ['timestamp']
        indexes = [
            models.Index(fields=['sender', 'receiver', 'timestamp']),
            models.Index(fields=['receiver', 'is_read', 'timestamp']),
            models.Index(fields=['timestamp']),
        ]
    
    def __str__(self):
        return f"{self.sender.get_full_name()} → {self.receiver.get_full_name()}: {self.message[:50]}"
    
    def mark_as_read(self):
        """Mark message as read"""
        from django.utils import timezone
        if not self.is_read:
            self.is_read = True
            self.read_at = timezone.now()
            self.save(update_fields=['is_read', 'read_at'])
    
    def mark_as_delivered(self):
        """Mark message as delivered"""
        if not self.is_delivered:
            self.is_delivered = True
            self.save(update_fields=['is_delivered'])
    
    def edit_message(self, new_message):
        """Edit the message content"""
        from django.utils import timezone
        self.message = new_message
        self.is_edited = True
        self.edited_at = timezone.now()
        self.save(update_fields=['message', 'is_edited', 'edited_at'])


class ChatRoom(models.Model):
    """Chat rooms for conversations between users"""
    
    ROOM_TYPE_CHOICES = [
        ('direct', 'Direct Message'),
        ('group', 'Group Chat'),
        ('support', 'Support Chat'),
        ('consultation', 'Consultation'),
    ]
    
    room_type = models.CharField(max_length=20, choices=ROOM_TYPE_CHOICES, default='direct')
    name = models.CharField(max_length=200, blank=True, help_text="For group chats")
    description = models.TextField(blank=True)
    
    # Participants
    participants = models.ManyToManyField(
        UserProfile, 
        related_name='chat_rooms',
        through='ChatRoomParticipant'
    )
    
    # Room settings
    is_active = models.BooleanField(default=True)
    is_private = models.BooleanField(default=True)
    created_by = models.ForeignKey(
        UserProfile, 
        on_delete=models.CASCADE, 
        related_name='created_chat_rooms'
    )
    
    # Timestamps
    created_at = models.DateTimeField(auto_now_add=True)
    updated_at = models.DateTimeField(auto_now=True)
    last_message_at = models.DateTimeField(null=True, blank=True)
    
    class Meta:
        verbose_name = 'Chat Room'
        verbose_name_plural = 'Chat Rooms'
        ordering = ['-last_message_at', '-created_at']
    
    def __str__(self):
        if self.room_type == 'direct':
            participants = list(self.participants.all())
            if len(participants) == 2:
                return f"Chat: {participants[0].get_full_name()} & {participants[1].get_full_name()}"
        return f"{self.name or 'Unnamed'} ({self.get_room_type_display()})"
    
    def get_last_message(self):
        """Get the last message in the chat room"""
        return self.messages.order_by('-timestamp').first()
    
    def update_last_message_time(self):
        """Update the last message timestamp"""
        from django.utils import timezone
        last_message = self.get_last_message()
        if last_message:
            self.last_message_at = last_message.timestamp
            self.save(update_fields=['last_message_at'])


class ChatRoomParticipant(models.Model):
    """Participants in chat rooms with additional metadata"""
    
    ROLE_CHOICES = [
        ('member', 'Member'),
        ('admin', 'Admin'),
        ('moderator', 'Moderator'),
        ('viewer', 'Viewer'),
    ]
    
    chat_room = models.ForeignKey(ChatRoom, on_delete=models.CASCADE)
    user = models.ForeignKey(UserProfile, on_delete=models.CASCADE)
    role = models.CharField(max_length=20, choices=ROLE_CHOICES, default='member')
    
    # Participation details
    joined_at = models.DateTimeField(auto_now_add=True)
    left_at = models.DateTimeField(null=True, blank=True)
    is_active = models.BooleanField(default=True)
    
    # Notification preferences
    mute_notifications = models.BooleanField(default=False)
    last_read_at = models.DateTimeField(null=True, blank=True)
    
    class Meta:
        verbose_name = 'Chat Room Participant'
        verbose_name_plural = 'Chat Room Participants'
        unique_together = ['chat_room', 'user']
        ordering = ['joined_at']
    
    def __str__(self):
        return f"{self.user.get_full_name()} in {self.chat_room}"
    
    def leave_room(self):
        """Mark participant as left"""
        from django.utils import timezone
        self.is_active = False
        self.left_at = timezone.now()
        self.save(update_fields=['is_active', 'left_at'])
    
    def mark_as_read(self):
        """Mark all messages as read for this participant"""
        from django.utils import timezone
        self.last_read_at = timezone.now()
        self.save(update_fields=['last_read_at'])
        
        # Mark unread messages as read
        unread_messages = HealthWorkerMessage.objects.filter(
            receiver=self.user,
            chat_room=self.chat_room,
            is_read=False
        )
        unread_messages.update(is_read=True, read_at=timezone.now())


class MessageAttachment(models.Model):
    """File attachments for chat messages"""
    
    ATTACHMENT_TYPE_CHOICES = [
        ('image', 'Image'),
        ('document', 'Document'),
        ('audio', 'Audio'),
        ('video', 'Video'),
        ('other', 'Other'),
    ]
    
    message = models.ForeignKey(
        HealthWorkerMessage, 
        on_delete=models.CASCADE, 
        related_name='message_attachments'
    )
    
    # File information
    file = models.FileField(upload_to='chat_attachments/')
    file_name = models.CharField(max_length=255)
    file_size = models.PositiveIntegerField(help_text="File size in bytes")
    file_type = models.CharField(max_length=20, choices=ATTACHMENT_TYPE_CHOICES)
    
    # Metadata
    description = models.CharField(max_length=500, blank=True)
    is_processed = models.BooleanField(default=False)
    
    # Timestamps
    uploaded_at = models.DateTimeField(auto_now_add=True)
    
    class Meta:
        verbose_name = 'Message Attachment'
        verbose_name_plural = 'Message Attachments'
        ordering = ['-uploaded_at']
    
    def __str__(self):
        return f"{self.file_name} ({self.get_file_type_display()})"
    
    def get_file_size_mb(self):
        """Get file size in MB"""
        return round(self.file_size / (1024 * 1024), 2)
    
    def get_file_extension(self):
        """Get file extension"""
        return self.file_name.split('.')[-1].lower() if '.' in self.file_name else ''
