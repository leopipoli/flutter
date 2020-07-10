class Medicos {
  //Atributos
  String _id;
  String _nome;
  String _especialidade;

  //Construtor
  Medicos(this._id, this._nome, this._especialidade);

  //Getters
  String get id => _id;
  String get nome => _nome;
  String get especialidade => _especialidade;

  Medicos.map(dynamic obj) {
    this._id = obj['id'];
    this._nome = obj['nome'];
    this._especialidade = obj['especialidade'];
  }

  //Converter os dados para um Mapa
  Map<String, dynamic> toMap() {
    var map = Map<String, dynamic>();
    if (_id != null) {
      map["id"] = _id;
    }
    map["nome"] = _nome;
    map["especialidade"] = _especialidade;
    return map;
  }

  //Converter um Mapa para o modelo de dados
  Medicos.fromMap(Map<String, dynamic> map, String id) {
    //Atribuir id ao this._id, somente se id não for
    //nulo, caso contrário atribui '' (vazio).
    this._id = id ?? '';
    this._nome = map['nome'];
    this._especialidade = map['especialidade'];
  }
}
