using Motqin.Enums;

namespace Motqin.Models
{
    public class FreeTime
    {
        public int Id { get; set; }

        public required string UserId { get; set; }

        public TimeOnly StartTime { get; set; }

        public TimeOnly EndTime { get; set; }

        public DateOnly StartDate { get; set; }

        public DateOnly EndDate { get; set; }

        public DayOfWeek Days { get; set; }
    }
}
