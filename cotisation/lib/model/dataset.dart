// ignore_for_file: camel_case_types

class Task {
  String? task;
  int? amount;

  Task({
    required this.task,
    required this.amount,
  });
}

List<Task> tasks = [
  Task(task: 'Nourriture', amount: 500),
  Task(task: 'Transport', amount: 2000),
  Task(task: 'Utilité', amount: 1000),
  Task(task: 'Urgence', amount: 800),
  Task(task: 'Médicaments', amount: 700),
  Task(task: 'Hébergement', amount: 1000),
  Task(task: 'Loisirs', amount: 400),
  Task(task: 'Assurance', amount: 2000),
  Task(task: 'Vêtements', amount: 2000),
  Task(task: 'Autres', amount: 1000),
  Task(task: 'Réception', amount: 1500),
  Task(task: 'Cadeaux', amount: 7000),
  Task(task: 'Photographie', amount: 400),
  Task(task: 'Musique', amount: 200),
  Task(task: 'Décoration', amount: 100),
  Task(task: 'Location', amount: 2000)
];
