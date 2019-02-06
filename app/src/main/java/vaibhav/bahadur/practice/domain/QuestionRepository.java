package vaibhav.bahadur.practice.domain;

import java.util.ArrayList;
import java.util.List;
import java.util.stream.Collectors;

public class QuestionRepository {

    public static List<Question> getQuestions(PracticeType practiceType) {
//        return getAllQuestions().stream()
//                .filter(q -> practiceType.name().equals(q.getPracticeType().name()))
//                .collect(Collectors.toList());
        return null;
    }

    private List<Question> getAllQuestions() {
        List<Question> questions = new ArrayList<>();
        questions.add(new Question("Write a joke", null, QuestionType.TEXT, PracticeType.JOKES));
        questions.add(new Question("Write something new you are grateful for in the last 24 hours", null, QuestionType.TEXT, PracticeType.GRATITUDE));
        return questions;
    }
}
