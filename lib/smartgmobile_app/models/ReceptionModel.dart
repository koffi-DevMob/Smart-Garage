class ReceptionModel {
  String recepId;
  String marque;
  String immatriculation;
  Null statusReparation;
  String cName;
  String siteNom;
  String dateReception;
  String lienFiche;

  ReceptionModel(
      {this.recepId,
        this.marque,
        this.immatriculation,
        this.statusReparation,
        this.cName,
        this.siteNom,
        this.dateReception,
        this.lienFiche});

  ReceptionModel.fromJson(Map<String, dynamic> json) {
    recepId = json['recep_id'];
    marque = json['marque'];
    immatriculation = json['immatriculation'];
    statusReparation = json['status_reparation'];
    cName = json['c_name'];
    siteNom = json['site_nom'];
    dateReception = json['date_reception'];
    lienFiche = json['lien_fiche'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['recep_id'] = this.recepId;
    data['marque'] = this.marque;
    data['immatriculation'] = this.immatriculation;
    data['status_reparation'] = this.statusReparation;
    data['c_name'] = this.cName;
    data['site_nom'] = this.siteNom;
    data['date_reception'] = this.dateReception;
    data['lien_fiche'] = this.lienFiche;
    return data;
  }
}
