class Agenda {
  //Atributos
  String _id;
  int _dia;
  String _mes;
  String _medico;

  //Construtor
  Agenda(this._id, this._dia, this._mes, this._medico);

  //Getters
  String get id => _id;
  int get dia => _dia;
  String get mes => _mes;
  String get medico => _medico;

  Agenda.map(dynamic obj) {
    this._id = obj['id'];
    this._dia = obj['dia'];
    this._mes = obj['mes'];
    this._medico = obj['medico'];
  }

  //Converter os dados para um Mapa
  Map<String, dynamic> toMap() {
    var map = Map<String, dynamic>();
    if (_id != null) {
      map["id"] = _id;
    }
    map["dia"] = _dia;
    map["mes"] = _mes;
    map["medico"] = _medico;
    return map;
  }

  //Converter um Mapa para o modelo de dados
  Agenda.fromMap(Map<String, dynamic> map, String id) {
    //Atribuir id ao this._id, somente se id não for
    //nulo, caso contrário atribui '' (vazio).
    this._id = id ?? '';
    this._dia = map['dia'];
    this._mes = map['mes'];
    this._medico = map['medico'];
  }
}
