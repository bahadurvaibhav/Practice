enum SkillType {
  Gratitude,
  CBT,
  What_Went_Well,
  Story_Journal,
  Joke,
  Blessings,
  Forgive,
  Story_Object,
  Story_DHV,
  Learning_Cornell_Note_Taking_System,
  Record_Joke,
  Face_Reading,
  Palmistry,
  Handwriting_Analysis,
}

String getSkillTypeDisplayValue(SkillType skillType) {
  switch (skillType) {
    case SkillType.Joke:
      return "Joke Journal";
    case SkillType.Gratitude:
    case SkillType.Blessings:
    case SkillType.Forgive:
    case SkillType.CBT:
    case SkillType.Palmistry:
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
    case SkillType.Face_Reading:
      return "Face Reading";
    case SkillType.Story_Journal:
      return "Story Journal";
    case SkillType.Handwriting_Analysis:
      return "Handwriting Analysis";
  }
}
