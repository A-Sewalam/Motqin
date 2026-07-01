namespace Motqin.Dtos.Question
{
    public class EndQuestionDto
    {
        public int SessionId { get; set; }
        public DateTime EndTime { get; set; }
        public string? UserAnswer { get; set; }
        public bool IsCorrect { get; set; }
    }
}
