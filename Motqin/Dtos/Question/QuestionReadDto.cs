namespace Motqin.Dtos.Question
{
    public class QuestionReadDto
    {
        public int QuestionID { get; set; }
        public int LessonID { get; set; }
        public string QuestionCategory { get; set; } = string.Empty;
        public string QuestionText { get; set; } = string.Empty;
        public string? DifficultyLevel { get; set; }
        public string? QuestionType { get; set; }

        // MCQ
        public string? AnswerOptions { get; set; }
        public string? CorrectAnswer { get; set; }

        // Fill
        public string? CorrectText { get; set; }
        public bool? CaseSensitive { get; set; }
    }
}
