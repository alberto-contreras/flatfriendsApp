class FlatModel {
  String _id;
  String _name;
  String _description;

  FlatModel();

  setID(String id)
  {
    this._id = id;
  }

  setName(String name)
  {
    this._name = name;
  }

  setDescription(String description)
  {
    this._description = description;
  }

  String getID()
  {
    return this._id;
  }

  String getName()
  {
    return this._name;
  }

  String getDescription()
  {
    return this._description;
  }


}