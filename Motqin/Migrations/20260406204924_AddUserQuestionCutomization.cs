using System;
using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace Motqin.Migrations
{
    /// <inheritdoc />
    public partial class AddUserQuestionCutomization : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.AddColumn<int>(
                name: "UserAddedQuestionID",
                table: "QuestionDetails",
                type: "int",
                nullable: true);

            migrationBuilder.CreateTable(
                name: "UserAddedQuestionDetails",
                columns: table => new
                {
                    DetailID = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    SessionID = table.Column<int>(type: "int", nullable: false),
                    QuestionID = table.Column<int>(type: "int", nullable: false),
                    StartTime = table.Column<DateTime>(type: "datetime2", nullable: false),
                    EndTime = table.Column<DateTime>(type: "datetime2", nullable: false),
                    UserAnswer = table.Column<string>(type: "nvarchar(max)", nullable: true),
                    IsCorrect = table.Column<bool>(type: "bit", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_UserAddedQuestionDetails", x => x.DetailID);
                    table.ForeignKey(
                        name: "FK_UserAddedQuestionDetails_Questions_QuestionID",
                        column: x => x.QuestionID,
                        principalTable: "Questions",
                        principalColumn: "QuestionID",
                        onDelete: ReferentialAction.Cascade);
                    table.ForeignKey(
                        name: "FK_UserAddedQuestionDetails_SpacedRepetitionSessions_SessionID",
                        column: x => x.SessionID,
                        principalTable: "SpacedRepetitionSessions",
                        principalColumn: "SessionID",
                        onDelete: ReferentialAction.Cascade);
                });

            migrationBuilder.CreateTable(
                name: "UserAddedQuestions",
                columns: table => new
                {
                    ID = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    LessonID = table.Column<int>(type: "int", nullable: false),
                    DisplayOrder = table.Column<int>(type: "int", nullable: false),
                    Priority = table.Column<int>(type: "int", nullable: false),
                    QuestionCategory = table.Column<string>(type: "nvarchar(max)", nullable: false),
                    QuestionText = table.Column<string>(type: "nvarchar(max)", nullable: false),
                    DifficultyLevel = table.Column<string>(type: "nvarchar(20)", maxLength: 20, nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_UserAddedQuestions", x => x.ID);
                    table.ForeignKey(
                        name: "FK_UserAddedQuestions_Lessons_LessonID",
                        column: x => x.LessonID,
                        principalTable: "Lessons",
                        principalColumn: "LessonID",
                        onDelete: ReferentialAction.Cascade);
                });

            migrationBuilder.CreateTable(
                name: "UserDeletedQuestions",
                columns: table => new
                {
                    Id = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    UserId = table.Column<string>(type: "nvarchar(max)", nullable: false),
                    QuestionId = table.Column<int>(type: "int", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_UserDeletedQuestions", x => x.Id);
                });

            migrationBuilder.CreateIndex(
                name: "IX_QuestionDetails_UserAddedQuestionID",
                table: "QuestionDetails",
                column: "UserAddedQuestionID");

            migrationBuilder.CreateIndex(
                name: "IX_UserAddedQuestionDetails_QuestionID",
                table: "UserAddedQuestionDetails",
                column: "QuestionID");

            migrationBuilder.CreateIndex(
                name: "IX_UserAddedQuestionDetails_SessionID",
                table: "UserAddedQuestionDetails",
                column: "SessionID");

            migrationBuilder.CreateIndex(
                name: "IX_UserAddedQuestions_LessonID",
                table: "UserAddedQuestions",
                column: "LessonID");

            migrationBuilder.AddForeignKey(
                name: "FK_QuestionDetails_UserAddedQuestions_UserAddedQuestionID",
                table: "QuestionDetails",
                column: "UserAddedQuestionID",
                principalTable: "UserAddedQuestions",
                principalColumn: "ID");
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropForeignKey(
                name: "FK_QuestionDetails_UserAddedQuestions_UserAddedQuestionID",
                table: "QuestionDetails");

            migrationBuilder.DropTable(
                name: "UserAddedQuestionDetails");

            migrationBuilder.DropTable(
                name: "UserAddedQuestions");

            migrationBuilder.DropTable(
                name: "UserDeletedQuestions");

            migrationBuilder.DropIndex(
                name: "IX_QuestionDetails_UserAddedQuestionID",
                table: "QuestionDetails");

            migrationBuilder.DropColumn(
                name: "UserAddedQuestionID",
                table: "QuestionDetails");
        }
    }
}
