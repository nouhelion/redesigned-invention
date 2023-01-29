List<List<dynamic>> matrix = [
  ['a', 1],
  ['b', 2],
  ['c', 3],
];

class Cotisation {
  String? task;
  int? amount;

  Cotisation({
    required this.task,
    required this.amount,
  });

  List<Cotisation> cotisations = [
  Cotisation(task: 'Nourriture', amount: 500),
  Cotisation(task: 'Transport', amount: 2000),
  Cotisation(task: 'Utilité', amount: 1000),
  Cotisation(task: 'Urgence', amount: 5000),
  Cotisation(task: 'Médicaments', amount: 3000),
  Cotisation(task: 'Hébergement', amount: 10000),
  Cotisation(task: 'Loisirs', amount: 4000),
  Cotisation(task: 'Assurance', amount: 2000),
  Cotisation(task: 'Vêtements', amount: 6000),
  Cotisation(task: 'Autres', amount: 1000),
  Cotisation(task: 'Réception', amount: 15000),
  Cotisation(task: 'Cadeaux', amount: 7000),
  Cotisation(task: 'Photographie', amount: 8000),
  Cotisation(task: 'Musique', amount: 9000),
  Cotisation(task: 'Décoration', amount: 10000),
  Cotisation(task: 'Location', amount:20000)
];
}
