enum SkillType {
  Joke,
  Gratitude,
  Story_Object,
  Story_DHV,
  Blessings,
  Forgive,
  What_Went_Well,
  Learning_Cornell_Note_Taking_System,
  Record_Joke,
}

String getSkillTypeDisplayValue(SkillType skillType) {
  switch (skillType) {
    case SkillType.Joke:
    case SkillType.Gratitude:
    case SkillType.Blessings:
    case SkillType.Forgive:
      return skillType
          .toString()
          .substring(skillType.toString().indexOf('.') + 1);
    case SkillType.Story_Object:
      return "Story - Object";
    case SkillType.Story_DHV:
      return "Story - DHV";
    case SkillType.What_Went_Well:
      return "What Went Well";
    case SkillType.Learning_Cornell_Note_Taking_System:
      return "Learning - Cornell Note";
    case SkillType.Record_Joke:
      return "Record Joke";
  }
}
