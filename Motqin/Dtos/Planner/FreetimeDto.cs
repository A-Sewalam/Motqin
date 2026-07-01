using Motqin.Enums;
using System.ComponentModel.DataAnnotations;

namespace Motqin.Dtos.Planner
{
    public class FreetimeDto
    {
        [Required]
        public required string UserId { get; set; }

        [Required]
        public TimeOnly StartTime { get; set; }

        [Required]
        public TimeOnly EndTime { get; set; }

        [Required]
        public DateOnly StartDate { get; set; }

        public DateOnly EndDate { get; set; }

        [Required]
        public DayOfWeek Days { get; set; }
    }
}
