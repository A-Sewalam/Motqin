using Microsoft.AspNetCore.Identity.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore;
using Motqin.Models;
using System.Numerics;

namespace Motqin.Data
{
    public class AppDbContext : IdentityDbContext<User>
    {
        public AppDbContext(DbContextOptions<AppDbContext> options)
            : base(options)
        {
        }

        // =========================
        // DbSets
        // =========================

        public DbSet<Subject> Subjects { get; set; }
        public DbSet<Lesson> Lessons { get; set; }

        public DbSet<Question> Questions { get; set; }
        public DbSet<QuestionDetails> QuestionDetails { get; set; }
        public DbSet<StudySession> StudySessions { get; set; }
        public DbSet<StudyPlan> StudyPlans { get; set; }

        public DbSet<DistractionControl> DistractionControls { get; set; }

        public DbSet<Competition> Competitions { get; set; }
        public DbSet<CompetitionEntry> CompetitionEntries { get; set; }

        // =========================
        // Fluent API Configuration
        // =========================

        protected override void OnModelCreating(ModelBuilder modelBuilder)
        {
            base.OnModelCreating(modelBuilder);

            // -------------------------------------------------
            // Question Inheritance (TPH - Table Per Hierarchy)
            // -------------------------------------------------
            modelBuilder.Entity<Question>()
                .HasDiscriminator<string>("QuestionType")
                .HasValue<MultipleChoiceQuestion>("MCQ")
                .HasValue<FillInTheBlankQuestion>("FILL");
              //"MCQ" → Multiple Choice Question - "FILL" → Fill -in-the - Blank Question

            // -------------------------------------------------
            // Subject → Lesson (1 : Many)
            // -------------------------------------------------
            modelBuilder.Entity<Lesson>()
                .HasOne(l => l.Subject)
                .WithMany(s => s.Lessons)
                .HasForeignKey(l => l.SubjectID)
                .OnDelete(DeleteBehavior.NoAction);

            // -------------------------------------------------
            // Lesson → Question (1 : Many)
            // -------------------------------------------------
            modelBuilder.Entity<Question>()
                .HasOne(q => q.Lesson)
                .WithMany(l => l.Questions)
                .HasForeignKey(q => q.LessonID)
                .OnDelete(DeleteBehavior.NoAction);
            
            // -------------------------------------------------
            // User → StudySession (1 : Many)
            // -------------------------------------------------
            modelBuilder.Entity<StudySession>()
                .HasOne(ss => ss.User)
                .WithMany(u => u.StudySessions)
                .HasForeignKey(ss => ss.UserID)
                .OnDelete(DeleteBehavior.NoAction);

            // -------------------------------------------------
            // Lesson → StudySession (1 : Many)
            // -------------------------------------------------
            modelBuilder.Entity<StudySession>()
                .HasOne(ss => ss.Lesson)
                .WithMany(l => l.StudySessions)
                .HasForeignKey(ss => ss.LessonID)
                .OnDelete(DeleteBehavior.NoAction);

            // -------------------------------------------------
            // StudySession → QuestionDetails (1 : Many)
            // -------------------------------------------------
            modelBuilder.Entity<QuestionDetails>()
                .HasOne(qd => qd.StudySession)
                .WithMany(ss => ss.QuestionDetails)
                .HasForeignKey(qd => qd.SessionID)
                .OnDelete(DeleteBehavior.NoAction);

            // -------------------------------------------------
            // Question → QuestionDetails (1 : Many)
            // -------------------------------------------------
            modelBuilder.Entity<QuestionDetails>()
                .HasOne(qd => qd.Question)
                .WithMany(q => q.QuestionDetails)
                .HasForeignKey(qd => qd.QuestionID)
                .OnDelete(DeleteBehavior.NoAction);

            // -------------------------------------------------
            // User → StudyPlan (1 : Many)
            // -------------------------------------------------
            modelBuilder.Entity<StudyPlan>()
                .HasOne(sp => sp.User)
                .WithMany(u => u.StudyPlans)
                .HasForeignKey(sp => sp.UserID)
                .OnDelete(DeleteBehavior.NoAction);

            // -------------------------------------------------
            // Lesson → StudyPlan (1 : Many)
            // -------------------------------------------------
            modelBuilder.Entity<StudyPlan>()
                .HasOne(sp => sp.Lesson)
                .WithMany(l => l.StudyPlans)
                .HasForeignKey(sp => sp.LessonID)
                .OnDelete(DeleteBehavior.NoAction);

            // -------------------------------------------------
            // User → DistractionControl (1 : Many)
            // -------------------------------------------------
            modelBuilder.Entity<DistractionControl>()
                .HasOne(dc => dc.User)
                .WithMany(u => u.DistractionControls)
                .HasForeignKey(dc => dc.UserID)
                .OnDelete(DeleteBehavior.NoAction);

            // -------------------------------------------------
            // Competition → CompetitionEntry (1 : Many)
            // -------------------------------------------------
            modelBuilder.Entity<CompetitionEntry>()
                .HasOne(ce => ce.Competition)
                .WithMany(c => c.CompetitionEntries)
                .HasForeignKey(ce => ce.CompetitionID)
                .OnDelete(DeleteBehavior.NoAction);

            // -------------------------------------------------
            // User → CompetitionEntry (1 : Many)
            // -------------------------------------------------
            modelBuilder.Entity<CompetitionEntry>()
                .HasOne(ce => ce.User)
                .WithMany(u => u.CompetitionEntries)
                .HasForeignKey(ce => ce.UserID)
                .OnDelete(DeleteBehavior.NoAction);
            // -------------------------------------------------
            // Subject → GradeLevel & EducationalStage (Enums)
            // -------------------------------------------------
            modelBuilder.Entity<Subject>()
                .Property(s => s.EducationalStage)
                .HasConversion<string>();

            modelBuilder.Entity<Subject>()
                .Property(s => s.GradeLevel)
                .HasConversion<string>();
        }
    }
}
