from peewee import *

class EventMessageType(Model):

    id = IntegerField(primary_key=True)
    string = CharField()

    class Meta:
        db_table = 'event_message_type'
