using Microsoft.VisualStudio.TestPlatform.ObjectModel.DataCollection;
using Motqin.Data;
using Motqin.Enums;
using Motqin.Models;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Net.Http.Json;
using System.Text;
using System.Threading.Tasks;

namespace Motqin_Tests;

public class QuestionTest : IntegrationTestBase
{
    public QuestionTest(ApiFactory<AppDbContext> factory) : base(factory) { }

    [Theory]
    [InlineData("MultipleChoice")]
    [InlineData("FillInTheBlank")]
    public async Task GetById_ReturnsCorrectType_WithSpecificProperties(string type)
    {
        // 1. Arrange: Setup the hierarchy
        var subject = new Subject { Name = "Science", Country = "Egypt", GradeLevel = GradeLevel.Third };
        DbContext.Subjects.Add(subject);
        await DbContext.SaveChangesAsync();

        var lesson = new Lesson { Title = "Atoms", SubjectID = subject.SubjectID };
        DbContext.Lessons.Add(lesson);
        await DbContext.SaveChangesAsync();

        // 2. Seed concrete data
        Question seededQuestion;
        if (type == "MultipleChoice")
        {
            seededQuestion = new MultipleChoiceQuestion
            {
                LessonID = lesson.LessonID,
                QuestionText = "Small?",
                AnswerOptions = "A,B,C",
                CorrectAnswer = "A",
                QuestionCategory = "Basic",
                DifficultyLevel = "Easy"
            };
        }
        else
        {
            seededQuestion = new FillInTheBlankQuestion
            {
                LessonID = lesson.LessonID,
                QuestionText = "Unit of ___",
                CorrectText = "Matter",
                CaseSensitive = true,
                QuestionCategory = "Basic",
                DifficultyLevel = "Easy"
            };
        }
        DbContext.Questions.Add(seededQuestion);
        await DbContext.SaveChangesAsync();
        DbContext.ChangeTracker.Clear(); // Critical: Force a fresh read from DB

        // 3. Act
        var response = await Client.GetAsync($"/api/questions/{seededQuestion.QuestionID}");

        // 4. Assert
        response.EnsureSuccessStatusCode();

        if (type == "MultipleChoice")
        {
            var result = await response.Content.ReadFromJsonAsync<MultipleChoiceQuestion>();
            Assert.NotNull(result);
            Assert.Equal("A,B,C", result.AnswerOptions); // Child property check
            Assert.Equal("A", result.CorrectAnswer);
        }
        else
        {
            var result = await response.Content.ReadFromJsonAsync<FillInTheBlankQuestion>();
            Assert.NotNull(result);
            Assert.Equal("Matter", result.CorrectText); // Child property check
            Assert.True(result.CaseSensitive);
        }
    }

    [Fact]
    public async Task GetById_IdNonExist_ReturnNotFound()
    {
        int nonExistenId = 99999;

        var response = await Client.GetAsync($"/api/questions/{nonExistenId}");

        Assert.Equal(System.Net.HttpStatusCode.NotFound, response.StatusCode);
    }

    [Fact]
    public async Task GetByLesson_ReturnsMixeQuestions_ForCorrectLesson()
    {
        // 1. Arrange: Seed Subject and two Lessons
        var subject = new Subject { Name = "General Science", Country = "Egypt", GradeLevel = GradeLevel.Third , EducationalStage = EducationalStage.Prepratory};
        DbContext.Subjects.Add(subject);
        await DbContext.SaveChangesAsync();

        var targetLesson = new Lesson { Title = "Cells", SubjectID = subject.SubjectID };
        var otherLesson = new Lesson { Title = "Space", SubjectID = subject.SubjectID };
        DbContext.Lessons.AddRange(targetLesson, otherLesson);
        await DbContext.SaveChangesAsync();

        // 2. Seed a mix of questions
        var q1 = new MultipleChoiceQuestion
        {
            LessonID = targetLesson.LessonID,
            QuestionText = "Choice Q",
            AnswerOptions = "A,B",
            CorrectAnswer = "A",
            QuestionCategory = "Basic",
            DifficultyLevel = "Easy"
        };
        var q2 = new FillInTheBlankQuestion
        {
            LessonID = targetLesson.LessonID,
            QuestionText = "Blank Q",
            CorrectText = "Nucleus",
            QuestionCategory = "Advanced",
            DifficultyLevel = "Easy"
        };
        var q3 = new MultipleChoiceQuestion
        {
            LessonID = otherLesson.LessonID, // Different lesson!
            QuestionText = "Should not appear",
            AnswerOptions = "X,Y",
            CorrectAnswer = "X",
            QuestionCategory = "Basic",
            DifficultyLevel = "Easy"
        };

        DbContext.Questions.AddRange(q1, q2, q3);
        await DbContext.SaveChangesAsync();
        DbContext.ChangeTracker.Clear();

        // 3. Act
        var response = await Client.GetAsync($"/api/questions/get-by-lesson?lessonId={targetLesson.LessonID}");

        // 4. Assert
        response.EnsureSuccessStatusCode();

        // We deserialize as the BASE type list
        var questions = await response.Content.ReadFromJsonAsync<List<Question>>();

        Assert.NotNull(questions);
        Assert.Equal(2, questions.Count); // Should only get q1 and q2

        // Verify polymorphism is working in the response
        var mcq = questions.OfType<MultipleChoiceQuestion>().FirstOrDefault();
        var fib = questions.OfType<FillInTheBlankQuestion>().FirstOrDefault();

        Assert.NotNull(mcq);
        Assert.Equal("A,B", mcq.AnswerOptions);

        Assert.NotNull(fib);
        Assert.Equal("Nucleus", fib.CorrectText);
    }

    [Fact]
    public async Task GeyByLesson_NonexistenLesson_ReturnNotFound()
    {
        int nonexistenLessonID = 99999;

        var response = await Client.GetAsync($"/api/questions/{nonexistenLessonID}");

        Assert.Equal(System.Net.HttpStatusCode.NotFound, response.StatusCode);
    }

    [Fact]
    public async Task GetByCategoryAndLesson_FiltersCorrectItems()
    {
        // 1. Arrange: Seed prerequisites
        var subject = new Subject { Name = "English", Country = "Egypt", GradeLevel = GradeLevel.Third , EducationalStage = EducationalStage.Prepratory};
        DbContext.Subjects.Add(subject);
        await DbContext.SaveChangesAsync();

        var lesson1 = new Lesson { Title = "Grammar", SubjectID = subject.SubjectID };
        var lesson2 = new Lesson { Title = "Vocab", SubjectID = subject.SubjectID };
        DbContext.Lessons.AddRange(lesson1, lesson2);
        await DbContext.SaveChangesAsync();

        // 2. Seed the Grid
        var match = new MultipleChoiceQuestion
        {
            LessonID = lesson1.LessonID,
            QuestionCategory = "Advanced",
            QuestionText = "Match Me",
            AnswerOptions = "A,B",
            CorrectAnswer = "A",
            DifficultyLevel = "Easy"
        };
        var wrongCategory = new FillInTheBlankQuestion
        {
            LessonID = lesson1.LessonID,
            QuestionCategory = "Basic", // Wrong Category
            QuestionText = "Don't Match Category",
            CorrectText = "Test",
            DifficultyLevel = "Easy"
        };
        var wrongLesson = new MultipleChoiceQuestion
        {
            LessonID = lesson2.LessonID, // Wrong Lesson
            QuestionCategory = "Advanced",
            QuestionText = "Don't Match Lesson",
            AnswerOptions = "X,Y",
            CorrectAnswer = "X",
            DifficultyLevel = "Easy"
        };

        DbContext.Questions.AddRange(match, wrongCategory, wrongLesson);
        await DbContext.SaveChangesAsync();
        DbContext.ChangeTracker.Clear();

        // 3. Act
        var response = await Client.GetAsync($"/api/questions/get-by-category-and-lesson?category=Advanced&lessonId={lesson1.LessonID}");

        // 4. Assert
        response.EnsureSuccessStatusCode();
        var result = await response.Content.ReadFromJsonAsync<List<Question>>();

        Assert.Single(result);
        Assert.Equal("Match Me", result[0].QuestionText);

        // Verify child properties are still there (Polymorphism Check)
        var mcq = result[0] as MultipleChoiceQuestion;
        Assert.NotNull(mcq);
        Assert.Equal("A,B", mcq.AnswerOptions);
    }

    [Fact]
    public async Task CreateMcq_ValidData_ReturnsCreatedAndPersistsChildData()
    {
        // 1. Arrange: Seed the parent Lesson
        var subject = new Subject { Name = "Chemistry", Country = "Egypt", GradeLevel = GradeLevel.Third , EducationalStage = EducationalStage.Prepratory};
        DbContext.Subjects.Add(subject);
        await DbContext.SaveChangesAsync();

        var lesson = new Lesson { Title = "Organic Chem", SubjectID = subject.SubjectID };
        DbContext.Lessons.Add(lesson);
        await DbContext.SaveChangesAsync();

        var mcqDto = new
        {
            LessonID = lesson.LessonID,
            QuestionCategory = "Basic",
            QuestionText = "What is the symbol for Gold?",
            DifficultyLevel = "Medium",
            AnswerOptions = "Au,Ag,Fe,Cu",
            CorrectAnswer = "Au",
        };

        // 2. Act
        var response = await Client.PostAsJsonAsync("/api/questions/mcq", mcqDto);

        // 3. Assert
        Assert.Equal(System.Net.HttpStatusCode.Created, response.StatusCode);

        var createdQuestion = await response.Content.ReadFromJsonAsync<MultipleChoiceQuestion>();
        Assert.NotNull(createdQuestion);
        Assert.Equal(mcqDto.AnswerOptions, createdQuestion.AnswerOptions);
        Assert.Equal("MultipleChoiceQuestion", createdQuestion.GetType().Name); // Confirming concrete type

        // 4. Verify in DB
        var dbQuestion = await DbContext.Questions.FindAsync(createdQuestion.QuestionID) as MultipleChoiceQuestion;
        Assert.NotNull(dbQuestion);
        Assert.Equal("Au", dbQuestion.CorrectAnswer);
    }

    [Fact]
    public async Task CreateMcq_InvalidLessonId_ReturnsBadRequest()
    {
        // Arrange
        var badMcq = new
        {
            LessonID = 99999, // Non-existent
            QuestionText = "Error Test",
            AnswerOptions = "A,B",
            CorrectAnswer = "A",
            QuestionCategory = "Test"
        };

        // Act
        var response = await Client.PostAsJsonAsync("/api/questions/mcq", badMcq);

        // Assert
        // If your controller has a check, this will be 400. 
        // If not, it might be 500 until you add the check.
        Assert.Equal(System.Net.HttpStatusCode.BadRequest, response.StatusCode);
    }

    [Fact]
    public async Task CreateFill_ValidData_ReturnsCreatedAndPersistsSpecificData()
    {
        // 1. Arrange: Seed prerequisites (Subject -> Lesson)
        var subject = new Subject { Name = "English", Country = "Egypt", GradeLevel = GradeLevel.First };
        DbContext.Subjects.Add(subject);
        await DbContext.SaveChangesAsync();

        var lesson = new Lesson { Title = "Grammar", SubjectID = subject.SubjectID };
        DbContext.Lessons.Add(lesson);
        await DbContext.SaveChangesAsync();

        var fillDto = new
        {
            LessonID = lesson.LessonID,
            QuestionCategory = "Basic",
            QuestionText = "The cat sat on the ___.",
            DifficultyLevel = "Easy",
            CorrectText = "Mat",
            CaseSensitive = false
        };

        // 2. Act
        var response = await Client.PostAsJsonAsync("/api/questions/fill", fillDto);

        // 3. Assert
        Assert.Equal(System.Net.HttpStatusCode.Created, response.StatusCode);

        var createdQuestion = await response.Content.ReadFromJsonAsync<FillInTheBlankQuestion>();
        Assert.NotNull(createdQuestion);
        Assert.Equal(fillDto.CorrectText, createdQuestion.CorrectText);
        Assert.False(createdQuestion.CaseSensitive);

        // 4. Verify in Database
        var dbQuestion = await DbContext.Questions.FindAsync(createdQuestion.QuestionID) as FillInTheBlankQuestion;
        Assert.NotNull(dbQuestion);
        Assert.Equal("Mat", dbQuestion.CorrectText);
    }

    [Fact]
    public async Task CreateFill_InvalidLessonId_ReturnsBadRequest()
    {
        // Arrange
        var badFill = new
        {
            LessonID = 99999, // Non-existent
            QuestionText = "Error Test",
            DifficultyLevel = "Easy",
            CorrectText = "Mat",
            CaseSensitive = false,
            QuestionCategory = "Test"
        };
            

        // Act
        var response = await Client.PostAsJsonAsync("/api/questions/mcq", badFill);

        // Assert
        // If your controller has a check, this will be 400. 
        // If not, it might be 500 until you add the check.
        Assert.Equal(System.Net.HttpStatusCode.BadRequest, response.StatusCode);
    }

    [Fact]
    public async Task Delete_QuestionExists_ReturnsNoContent_AndRemovesFromDb()
    {
        // 1. Arrange: Seed the hierarchy
        var subject = new Subject { Name = "Science", Country = "Egypt", GradeLevel = GradeLevel.Third };
        DbContext.Subjects.Add(subject);
        await DbContext.SaveChangesAsync();

        var lesson = new Lesson { Title = "Cells", SubjectID = subject.SubjectID };
        DbContext.Lessons.Add(lesson);
        await DbContext.SaveChangesAsync();

        var question = new MultipleChoiceQuestion
        {
            LessonID = lesson.LessonID,
            QuestionText = "To be deleted",
            AnswerOptions = "A,B",
            CorrectAnswer = "A",
            QuestionCategory = "Basic",
            DifficultyLevel = "Easy"
        };
        DbContext.Questions.Add(question);
        await DbContext.SaveChangesAsync();

        DbContext.ChangeTracker.Clear();

        // 2. Act
        var response = await Client.DeleteAsync($"/api/questions/{question.QuestionID}");

        // 3. Assert
        Assert.Equal(System.Net.HttpStatusCode.NoContent, response.StatusCode);

        // Verify it's actually gone from the database
        var dbQuestion = await DbContext.Questions.FindAsync(question.QuestionID);
        Assert.Null(dbQuestion);
    }
}
