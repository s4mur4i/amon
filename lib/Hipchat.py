import hipchat


class Hipchat(object):
    def __init__(self):
        # Key with permission to only send messages
        # self.hipster = hipchat.HipChat("")
        # Key with permission to query rooms
        self.hipster = hipchat.HipChat("")

    def get_room(self, room_name):
        room = self.hipster.find_room(room_name)
        return room

    def send_msg_to_room(self, room_id, from_name, message, notify=False, message_color=None):
        if message_color:
            self.hipster.message_room(room_id, from_name, message, color=message_color, notify=notify)
        else:
            self.hipster.message_room(room_id, from_name, message, notify=notify)

    def send_notification_to_developers(self,message):
        room = self.get_room(room_name="")
        self.send_msg_to_room(from_name="Amon",message=message,room_id=room['room_id'])

    def send_notification_to_devops(self,message,status=None):
        room = self.get_room(room_name="")
        if status == "start":
            self.send_msg_to_room(from_name="Amon",message=message,room_id=room['room_id'],message_color="yellow")
        elif status == "finish":
            self.send_msg_to_room(from_name="Amon",message=message,room_id=room['room_id'],message_color="green")
        elif status == "":
            self.send_msg_to_room(from_name="Amon",message=message,room_id=room['room_id'],message_color="gray")
        else:
            self.send_msg_to_room(from_name="Amon",message=message,room_id=room['room_id'],message_color="red")

    def send_notification_to_s4mur4i(self,message,status=None):
        room = self.get_room(room_name="")
        if status == "start":
            self.send_msg_to_room(from_name="Amon",message=message,room_id=room['room_id'],message_color="gray")
        elif status == "finish":
            self.send_msg_to_room(from_name="Amon",message=message,room_id=room['room_id'],message_color="green")
        elif status == "":
            self.send_msg_to_room(from_name="Amon",message=message,room_id=room['room_id'],message_color="gray")
        else:
            self.send_msg_to_room(from_name="Amon",message=message,room_id=room['room_id'],message_color="red")

hc = Hipchat()
