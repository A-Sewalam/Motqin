using System;
using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace Motqin.Migrations
{
    /// <inheritdoc />
    public partial class ModifyStudySession : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropForeignKey(
                name: "FK_QuestionDetails_SpacedRepetitionSessions_SessionID",
                table: "QuestionDetails");

            migrationBuilder.DropForeignKey(
                name: "FK_StudyPlans_SpacedRepetitionSessions_SpacedRepetitionSessionId",
                table: "StudyPlans");

            migrationBuilder.DropForeignKey(
                name: "FK_StudySessions_AspNetUsers_UserID",
                table: "StudySessions");

            migrationBuilder.DropForeignKey(
                name: "FK_StudySessions_Lessons_LessonID",
                table: "StudySessions");

            migrationBuilder.DropForeignKey(
                name: "FK_UserAddedQuestionDetails_SpacedRepetitionSessions_SessionID",
                table: "UserAddedQuestionDetails");

            migrationBuilder.DropTable(
                name: "SpacedRepetitionSessions");

            migrationBuilder.AddColumn<string>(
                name: "Discriminator",
                table: "StudySessions",
                type: "nvarchar(34)",
                maxLength: 34,
                nullable: false,
                defaultValue: "");

            migrationBuilder.AddColumn<string>(
                name: "QuestionsCategory",
                table: "StudySessions",
                type: "nvarchar(max)",
                nullable: true);

            migrationBuilder.AddColumn<int>(
                name: "RepetitionNumber",
                table: "StudySessions",
                type: "int",
                nullable: true);

            migrationBuilder.AddColumn<int>(
                name: "Score",
                table: "StudySessions",
                type: "int",
                nullable: true);

            migrationBuilder.AddColumn<byte>(
                name: "StudySessionStatuses",
                table: "StudySessions",
                type: "tinyint",
                nullable: true);

            migrationBuilder.AddForeignKey(
                name: "FK_QuestionDetails_StudySessions_SessionID",
                table: "QuestionDetails",
                column: "SessionID",
                principalTable: "StudySessions",
                principalColumn: "SessionID");

            migrationBuilder.AddForeignKey(
                name: "FK_StudyPlans_StudySessions_SpacedRepetitionSessionId",
                table: "StudyPlans",
                column: "SpacedRepetitionSessionId",
                principalTable: "StudySessions",
                principalColumn: "SessionID",
                onDelete: ReferentialAction.Cascade);

            migrationBuilder.AddForeignKey(
                name: "FK_StudySessions_AspNetUsers_UserID",
                table: "StudySessions",
                column: "UserID",
                principalTable: "AspNetUsers",
                principalColumn: "Id");

            migrationBuilder.AddForeignKey(
                name: "FK_StudySessions_Lessons_LessonID",
                table: "StudySessions",
                column: "LessonID",
                principalTable: "Lessons",
                principalColumn: "LessonID");

            migrationBuilder.AddForeignKey(
                name: "FK_UserAddedQuestionDetails_StudySessions_SessionID",
                table: "UserAddedQuestionDetails",
                column: "SessionID",
                principalTable: "StudySessions",
                principalColumn: "SessionID",
                onDelete: ReferentialAction.Cascade);
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropForeignKey(
                name: "FK_QuestionDetails_StudySessions_SessionID",
                table: "QuestionDetails");

            migrationBuilder.DropForeignKey(
                name: "FK_StudyPlans_StudySessions_SpacedRepetitionSessionId",
                table: "StudyPlans");

            migrationBuilder.DropForeignKey(
                name: "FK_StudySessions_AspNetUsers_UserID",
                table: "StudySessions");

            migrationBuilder.DropForeignKey(
                name: "FK_StudySessions_Lessons_LessonID",
                table: "StudySessions");

            migrationBuilder.DropForeignKey(
                name: "FK_UserAddedQuestionDetails_StudySessions_SessionID",
                table: "UserAddedQuestionDetails");

            migrationBuilder.DropColumn(
                name: "Discriminator",
                table: "StudySessions");

            migrationBuilder.DropColumn(
                name: "QuestionsCategory",
                table: "StudySessions");

            migrationBuilder.DropColumn(
                name: "RepetitionNumber",
                table: "StudySessions");

            migrationBuilder.DropColumn(
                name: "Score",
                table: "StudySessions");

            migrationBuilder.DropColumn(
                name: "StudySessionStatuses",
                table: "StudySessions");

            migrationBuilder.CreateTable(
                name: "SpacedRepetitionSessions",
                columns: table => new
                {
                    SessionID = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    LessonID = table.Column<int>(type: "int", nullable: false),
                    SubjectID = table.Column<int>(type: "int", nullable: false),
                    UserID = table.Column<string>(type: "nvarchar(450)", nullable: false),
                    EndTime = table.Column<DateTime>(type: "datetime2", nullable: true),
                    QuestionsCategory = table.Column<string>(type: "nvarchar(max)", nullable: false),
                    RepetitionNumber = table.Column<int>(type: "int", nullable: false),
                    Score = table.Column<int>(type: "int", nullable: false),
                    StartTime = table.Column<DateTime>(type: "datetime2", nullable: false),
                    StudySessionStatuses = table.Column<byte>(type: "tinyint", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_SpacedRepetitionSessions", x => x.SessionID);
                    table.ForeignKey(
                        name: "FK_SpacedRepetitionSessions_AspNetUsers_UserID",
                        column: x => x.UserID,
                        principalTable: "AspNetUsers",
                        principalColumn: "Id");
                    table.ForeignKey(
                        name: "FK_SpacedRepetitionSessions_Lessons_LessonID",
                        column: x => x.LessonID,
                        principalTable: "Lessons",
                        principalColumn: "LessonID");
                    table.ForeignKey(
                        name: "FK_SpacedRepetitionSessions_Lessons_SubjectID",
                        column: x => x.SubjectID,
                        principalTable: "Lessons",
                        principalColumn: "LessonID",
                        onDelete: ReferentialAction.Cascade);
                });

            migrationBuilder.CreateIndex(
                name: "IX_SpacedRepetitionSessions_LessonID",
                table: "SpacedRepetitionSessions",
                column: "LessonID");

            migrationBuilder.CreateIndex(
                name: "IX_SpacedRepetitionSessions_SubjectID",
                table: "SpacedRepetitionSessions",
                column: "SubjectID");

            migrationBuilder.CreateIndex(
                name: "IX_SpacedRepetitionSessions_UserID",
                table: "SpacedRepetitionSessions",
                column: "UserID");

            migrationBuilder.AddForeignKey(
                name: "FK_QuestionDetails_SpacedRepetitionSessions_SessionID",
                table: "QuestionDetails",
                column: "SessionID",
                principalTable: "SpacedRepetitionSessions",
                principalColumn: "SessionID");

            migrationBuilder.AddForeignKey(
                name: "FK_StudyPlans_SpacedRepetitionSessions_SpacedRepetitionSessionId",
                table: "StudyPlans",
                column: "SpacedRepetitionSessionId",
                principalTable: "SpacedRepetitionSessions",
                principalColumn: "SessionID",
                onDelete: ReferentialAction.Cascade);

            migrationBuilder.AddForeignKey(
                name: "FK_StudySessions_AspNetUsers_UserID",
                table: "StudySessions",
                column: "UserID",
                principalTable: "AspNetUsers",
                principalColumn: "Id",
                onDelete: ReferentialAction.Cascade);

            migrationBuilder.AddForeignKey(
                name: "FK_StudySessions_Lessons_LessonID",
                table: "StudySessions",
                column: "LessonID",
                principalTable: "Lessons",
                principalColumn: "LessonID",
                onDelete: ReferentialAction.Cascade);

            migrationBuilder.AddForeignKey(
                name: "FK_UserAddedQuestionDetails_SpacedRepetitionSessions_SessionID",
                table: "UserAddedQuestionDetails",
                column: "SessionID",
                principalTable: "SpacedRepetitionSessions",
                principalColumn: "SessionID",
                onDelete: ReferentialAction.Cascade);
        }
    }
}
