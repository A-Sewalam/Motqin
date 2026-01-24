using Motqin.Enums;
using System.ComponentModel.DataAnnotations;

namespace Motqin.Dtos.Subject
{
    public class SubjectReadDto
    {
        public int SubjectID { get; set; }
        public required string Name { get; set; }
        public required string Country { get; set; }
        public EducationalStage EducationalStage { get; set; }
        public GradeLevel GradeLevel { get; set; }
    }
}
