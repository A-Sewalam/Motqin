using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace Motqin.Models.Session
{
    public class StudySession : Session
    {
        [Required]
        public int LessonID { get; set; }

        [Required]
        public int SubjectID { get; set; }

        [ForeignKey("LessonID")]
        public virtual Lesson Lesson { get; set; }

        [ForeignKey("SubjectID")]
        public virtual Lesson Subject { get; set; }
    }
}
