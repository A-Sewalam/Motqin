using Microsoft.AspNetCore.Builder;
using Microsoft.Extensions.DependencyInjection;
using Motqin.Models;
using System;
using System.Linq;

namespace Motqin.Data
{
    public class AppDbInitializer
    {
        //public static void Seed(IServiceProvider serviceProvider)
        //{
        //    using (var serviceScope = serviceProvider.CreateScope())
        //    {
        //        var context = serviceScope.ServiceProvider.GetService<AppDbContext>();

        //        if (context == null)
        //        {
        //            throw new Exception("DbContext not found in Service Provider");
        //        }

        //        // Ensure the database exists before querying .Any()
        //        context.Database.EnsureCreated();

        //        // =========================
        //        // SUBJECT
        //        // =========================
        //        if (!context.Subjects.Any())
        //        {
        //            context.Subjects.Add(new Subject
        //            {
        //                Name = "English",
        //                Country = "Egypt",
        //                EducationalStage = Enums.EducationalStage.Secondary,
        //                GradeLevel = Enums.GradeLevel.Third
        //            });
        //            context.SaveChanges();
        //        }

        //        var englishSubject = context.Subjects.FirstOrDefault();

        //        // =========================
        //        // LESSONS
        //        // =========================
        //        if (!context.Lessons.Any())
        //        {
        //            context.Lessons.AddRange(
        //                new Lesson
        //                {
        //                    SubjectID = englishSubject.SubjectID,
        //                    Title = "Grammar: Conditional Sentences"
        //                },
        //                new Lesson
        //                {
        //                    SubjectID = englishSubject.SubjectID,
        //                    Title = "Vocabulary: Science and Technology"
        //                }
        //            );
        //            context.SaveChanges();
        //        }

        //        var lesson1 = context.Lessons.First();
        //        var lesson2 = context.Lessons.Skip(1).First();

        //        // =========================
        //        // USERS
        //        // =========================
        //        if (!context.Users.Any())
        //        {
        //            context.Users.AddRange(
        //                new User
        //                {
        //                    Name = "Ahmed Hassan",
        //                    Email = "ahmed@student.com",
        //                    PasswordHash = "HASHED_PASSWORD",
        //                    Role = "Student",
        //                    GradeLevel = Enums.GradeLevel.Third,
        //                    Country = "Egypt",
        //                    EducationalStage = Enums.EducationalStage.Secondary
        //                },
        //                new User
        //                {
        //                    Name = "Sara Ali",
        //                    Email = "sara@student.com",
        //                    PasswordHash = "HASHED_PASSWORD",
        //                    Role = "Student",
        //                    GradeLevel = Enums.GradeLevel.Third,
        //                    Country = "Egypt",
        //                    EducationalStage = Enums.EducationalStage.Secondary
        //                }
        //            );
        //            context.SaveChanges();
        //        }

        //        var user = context.Users.First();

        //        // =========================
        //        // QUESTIONS
        //        // =========================
        //        if (!context.Questions.Any())
        //        {
        //            context.Questions.AddRange(

        //                new MultipleChoiceQuestion
        //                {
        //                    LessonID = lesson1.LessonID,
        //                    QuestionCategory = "Basic",
        //                    QuestionText = "If I study hard, I ____ pass the exam.",
        //                    AnswerOptions = "[\"will\",\"would\",\"had\",\"have\"]",
        //                    CorrectAnswer = "will",
        //                    DifficultyLevel = "Easy"
        //                },

        //                new FillInTheBlankQuestion
        //                {
        //                    LessonID = lesson2.LessonID,
        //                    QuestionCategory = "Middle",
        //                    QuestionText = "Technology has made our lives _____.",
        //                    CorrectText = "easier",
        //                    CaseSensitive = false,
        //                    DifficultyLevel = "Easy"
        //                }
        //            );
        //            context.SaveChanges();
        //        }

        //        var question = context.Questions.First();

        //        // =========================
        //        // STUDY SESSION
        //        // =========================
        //        if (!context.StudySessions.Any())
        //        {
        //            context.StudySessions.Add(new StudySession
        //            {
        //                UserID = user.Id,
        //                LessonID = lesson1.LessonID,
        //                QuestionsCategory = "Basic",
        //                StartTime = DateTime.Now.AddMinutes(-30),
        //                EndTime = DateTime.Now,
        //                Score = 80
        //            });
        //            context.SaveChanges();
        //        }

        //        var session = context.StudySessions.First();

        //        // =========================
        //        // QUESTION DETAILS
        //        // =========================
        //        if (!context.QuestionDetails.Any())
        //        {
        //            context.QuestionDetails.Add(new QuestionDetails
        //            {
        //                SessionID = session.SessionID,
        //                QuestionID = question.QuestionID,
        //                StartTime = DateTime.Now.AddMinutes(-25),
        //                EndTime = DateTime.Now.AddMinutes(-23),
        //                UserAnswer = "will",
        //                IsCorrect = true
        //            });
        //            context.SaveChanges();
        //        }

        //        // =========================
        //        // STUDY PLAN
        //        // =========================
        //        if (!context.StudyPlans.Any())
        //        {
        //            context.StudyPlans.Add(new StudyPlan
        //            {
        //                UserID = user.Id,
        //                LessonID = lesson1.LessonID,
        //                NextReviewDate = DateTime.Now.AddDays(3),
        //                ReviewInterval = 3,
        //                Status = "Active"
        //            });
        //            context.SaveChanges();
        //      }
        //    }
        //}
    }
}
