namespace Motqin.Dtos.Question
{
    public class QuestionDetailsDto
    {
        public int DetailID { get; set; }
        public int SessionID { get; set; }
        public int QuestionID { get; set; }
        public DateTime StartTime { get; set; }
        public DateTime? EndTime { get; set; }
        public string? UserAnswer { get; set; }
        public bool IsCorrect { get; set; }
    }
}
