class Message
{
  String name;
  String text;

  Message(this.name, this.text);
  Message.fromMap(Map map) : this(map['name'], map['text']);
  Map toMap() => {
    "name" : name,
    "text" : text
  };

}
