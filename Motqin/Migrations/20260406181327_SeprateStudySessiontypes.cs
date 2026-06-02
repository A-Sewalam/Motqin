using System;
using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace Motqin.Migrations
{
    /// <inheritdoc />
    public partial class SeprateStudySessiontypes : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropForeignKey(
                name: "FK_QuestionDetails_StudySessions_SessionID",
                table: "QuestionDetails");

            migrationBuilder.DropForeignKey(
                name: "FK_StudySessions_AspNetUsers_UserID",
                table: "StudySessions");

            migrationBuilder.DropForeignKey(
                name: "FK_StudySessions_Lessons_LessonID",
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
                    SubjectID = table.Column<int>(type: "int", nullable: false),
                    LessonID = table.Column<int>(type: "int", nullable: false),
                    QuestionsCategory = table.Column<string>(type: "nvarchar(max)", nullable: false),
                    RepetitionNumber = table.Column<int>(type: "int", nullable: false),
                    StudySessionStatuses = table.Column<byte>(type: "tinyint", nullable: false),
                    Score = table.Column<int>(type: "int", nullable: false),
                    UserID = table.Column<string>(type: "nvarchar(450)", nullable: false),
                    StartTime = table.Column<DateTime>(type: "datetime2", nullable: false),
                    EndTime = table.Column<DateTime>(type: "datetime2", nullable: true)
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
                        onDelete: ReferentialAction.NoAction);
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
                name: "FK_StudySessions_AspNetUsers_UserID",
                table: "StudySessions",
                column: "UserID",
                principalTable: "AspNetUsers",
                principalColumn: "Id",
                onDelete: ReferentialAction.NoAction);

            migrationBuilder.AddForeignKey(
                name: "FK_StudySessions_Lessons_LessonID",
                table: "StudySessions",
                column: "LessonID",
                principalTable: "Lessons",
                principalColumn: "LessonID",
                onDelete: ReferentialAction.NoAction);
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropForeignKey(
                name: "FK_QuestionDetails_SpacedRepetitionSessions_SessionID",
                table: "QuestionDetails");

            migrationBuilder.DropForeignKey(
                name: "FK_StudySessions_AspNetUsers_UserID",
                table: "StudySessions");

            migrationBuilder.DropForeignKey(
                name: "FK_StudySessions_Lessons_LessonID",
                table: "StudySessions");

            migrationBuilder.DropTable(
                name: "SpacedRepetitionSessions");

            migrationBuilder.AddColumn<string>(
                name: "QuestionsCategory",
                table: "StudySessions",
                type: "nvarchar(max)",
                nullable: false,
                defaultValue: "");

            migrationBuilder.AddColumn<int>(
                name: "RepetitionNumber",
                table: "StudySessions",
                type: "int",
                nullable: false,
                defaultValue: 0);

            migrationBuilder.AddColumn<int>(
                name: "Score",
                table: "StudySessions",
                type: "int",
                nullable: false,
                defaultValue: 0);

            migrationBuilder.AddColumn<byte>(
                name: "StudySessionStatuses",
                table: "StudySessions",
                type: "tinyint",
                nullable: false,
                defaultValue: (byte)0);

            migrationBuilder.AddForeignKey(
                name: "FK_QuestionDetails_StudySessions_SessionID",
                table: "QuestionDetails",
                column: "SessionID",
                principalTable: "StudySessions",
                principalColumn: "SessionID");

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
        }
    }
}
