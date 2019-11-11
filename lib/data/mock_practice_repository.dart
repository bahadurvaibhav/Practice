import 'dart:async';

import 'practice_item.dart';

class MockPracticeRepository implements PracticeRepository {
  Future<List<PracticeItem>> fetch() {
    return Future.value(kContacts);
  }
}

const kContacts = <PracticeItem>[
  PracticeItem(
      skillType: 'Romain Hoogmoed', createdAt: 'romain.hoogmoed@example.com'),
  PracticeItem(
      skillType: 'Emilie Olsen', createdAt: 'emilie.olsen@example.com'),
  PracticeItem(skillType: 'Téo Lefevre', createdAt: 'téo.lefevre@example.com'),
  PracticeItem(skillType: 'Nicole Cruz', createdAt: 'nicole.cruz@example.com'),
  PracticeItem(
      skillType: 'Ramna Peixoto', createdAt: 'ramna.peixoto@example.com'),
  PracticeItem(skillType: 'Jose Ortiz', createdAt: 'jose.ortiz@example.com'),
  PracticeItem(
      skillType: 'Alma Christensen', createdAt: 'alma.christensen@example.com'),
  PracticeItem(skillType: 'Sergio Hill', createdAt: 'sergio.hill@example.com'),
  PracticeItem(
      skillType: 'Malo Gonzalez', createdAt: 'malo.gonzalez@example.com'),
  PracticeItem(
      skillType: 'Miguel Owens', createdAt: 'miguel.owens@example.com'),
  PracticeItem(
      skillType: 'Lilou Dumont', createdAt: 'lilou.dumont@example.com'),
  PracticeItem(
      skillType: 'Ashley Stewart', createdAt: 'ashley.stewart@example.com'),
  PracticeItem(skillType: 'Roman Zhang', createdAt: 'roman.zhang@example.com'),
  PracticeItem(
      skillType: 'Ryan Roberts', createdAt: 'ryan.roberts@example.com'),
  PracticeItem(
      skillType: 'Sadie Thomas', createdAt: 'sadie.thomas@example.com'),
  PracticeItem(
      skillType: 'Belen Serrano', createdAt: 'belen.serrano@example.com ')
];
