namespace Motqin.Dtos.Planner
{
    public class ToStudyDto
    {
        public string UserID { get; set; }
        public int SubjectID { get; set; }
        public int LessonId { get; set; }
        public string Title { get; set; }
        public int Difficulty { get; set; }
        public int? EstimatedDuration { get; set; }
    }
}
