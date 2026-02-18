using Motqin.Enums;
using System.ComponentModel.DataAnnotations;

namespace Motqin.Dtos.Subject
{
    public class SubjectDto
    {
        [Required]
        [StringLength(100)]
        public required string Name { get; set; }

        [StringLength(100)]
        public required string Country { get; set; }

        public EducationalStage EducationalStage { get; set; }

        public GradeLevel GradeLevel { get; set; }

    }
}
