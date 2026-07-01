namespace Motqin.Models
{
    public class UserLessons
    {
        public int Id { get; set; }
        public string UserId { get; set; }
        public User User { get; set; }
        public int LessonId { get; set; }
        public Lesson Lesson { get; set; }
        public bool Complted { get; set; }
    }
}
