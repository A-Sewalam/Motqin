using Google.GenAI;
using Microsoft.AspNetCore.Http.HttpResults;
using Microsoft.EntityFrameworkCore;
using Motqin.Data;
using Motqin.Dtos.Planner;
using Motqin.Models;

namespace Motqin.Services
{
    public interface IPlannerService
    {
        Task<FreeTime> AddFreeTime(FreetimeDto freeTime);
        Task<UserLessons> AddLessonToBeStudied(ToBeStudiedDto userLesson);
        Task DeleteFreeTime(int id);
        Task<IEnumerable<FreeTime>> GetFreeTimes(string UserId);
        Task<IEnumerable<ToReviewDto>> GetLessonsToReview(string UserId);
        Task<IEnumerable<ToStudyDto>> GetLessonsToStudy(string UserId);
        Task<string> Plan(string UserId);
    }

    public class PlannerService : IPlannerService
    {
        private readonly AppDbContext context;

        public PlannerService(AppDbContext context)
        {
            this.context = context;
        }
        public async Task<FreeTime> AddFreeTime(FreetimeDto freeTime)
        {
            var freetime = new FreeTime()
            {
                UserId = freeTime.UserId,
                StartTime = freeTime.StartTime,
                EndTime = freeTime.EndTime,
                StartDate = freeTime.StartDate,
                EndDate = freeTime.EndDate,
                Days = freeTime.Days
            };
            await context.UserFreeTimes.AddAsync(freetime);
            await context.SaveChangesAsync();
            return freetime;
        }

        public async Task DeleteFreeTime(int id)
        {
            var freetime = await context.UserFreeTimes.FindAsync(id);
            if (freetime == null) return;
            context.UserFreeTimes.Remove(freetime);
            await context.SaveChangesAsync();
        }

        public async Task<UserLessons> AddLessonToBeStudied(ToBeStudiedDto userLesson)
        {
            var userlesson = new UserLessons()
            {
                UserId = userLesson.UserId,
                LessonId = userLesson.LessonId,
                Complted = false
            };
            await context.UserToBeStudiedLessons.AddAsync(userlesson);
            await context.SaveChangesAsync();
            return userlesson;
        }
        public async Task<IEnumerable<ToStudyDto>> GetLessonsToStudy(string UserId) =>
            await context.UserToBeStudiedLessons
            .Where(lesson => lesson.UserId == UserId)
            .Select(s => new ToStudyDto
            {
                UserID = s.UserId,
                SubjectID = s.Lesson.SubjectID,
                LessonId = s.LessonId,
                Title = s.Lesson.Title,
                Difficulty = s.Lesson.Difficulty,
                EstimatedDuration = s.Lesson.EstimatedDuration
            })
            .ToListAsync();

        public async Task<IEnumerable<FreeTime>> GetFreeTimes(string UserId) =>
            await context.UserFreeTimes
            .Where(f => f.UserId == UserId)
            .ToListAsync();
        public async Task<IEnumerable<ToReviewDto>> GetLessonsToReview(string UserId) =>
    await context.SpacedRepetitionSessions
        .Where(s => s.UserId == UserId)
        .OrderBy(s => s.LastReviewDate)
        .ThenBy(s => s.RepetitionNumber)
        .Take(20)
        .Select(s => new ToReviewDto
        {
            UserID = s.UserId,
            SubjectID = s.Lesson.SubjectID,
            LessonId = s.LessonId,
            Title = s.Lesson.Title,
            Difficulty = s.Lesson.Difficulty,
            EstimatedDuration = s.Lesson.EstimatedDuration,
            RepetitionNumber = s.RepetitionNumber,
            AverageScore = s.Score,
            LastReviewDate = s.LastReviewDate
        })
        .ToListAsync();

        public async Task<string> Plan(string UserId)
        {
            var lessons = context.UserToBeStudiedLessons.Where(lesson => lesson.UserId == UserId).Select(l => l.Lesson);
            var freetimes = context.UserFreeTimes.Where(f => f.UserId == UserId);
            string? apiKey = Environment.GetEnvironmentVariable("GeminiApiKey");
            if (apiKey != null)
            {
                var client = new Client(apiKey: apiKey);
                try
                {
                    var response = await client.Models.GenerateContentAsync(
                        model: "gemini-2.5-flash",
                        contents: "Explain the concept of 'async/await' in C# in two sentences."
                    );
                    string reply = response.Candidates[0].Content.Parts[0].Text;
                    if (reply != null) return reply;
                }
                catch (Exception ex)
                {
                    Console.WriteLine($"Error: {ex.Message}");
                }

            }
            return string.Empty;
        }
    }
}
