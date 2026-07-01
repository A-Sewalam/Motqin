namespace Motqin.Dtos.Planner
{
    public class ToReviewDto
    {
        public string UserID { get; set; }
        public int SubjectID { get; set; }
        public int LessonId { get; set; }
        public string Title { get; set; } 
        public int Difficulty { get; set; }
        public int? EstimatedDuration { get; set; }
        public int RepetitionNumber { get; set; }
        public int AverageScore { get; set; }
        public DateOnly LastReviewDate { get; set; }
    }
}
