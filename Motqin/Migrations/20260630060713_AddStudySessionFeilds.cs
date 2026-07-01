using System;
using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace Motqin.Migrations
{
    /// <inheritdoc />
    public partial class AddStudySessionFeilds : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
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
                name: "RepetitionNumber",
                table: "StudySessions");

            migrationBuilder.RenameColumn(
                name: "LessonID",
                table: "Lessons",
                newName: "LessonId");

            migrationBuilder.AlterColumn<int>(
                name: "Score",
                table: "StudySessions",
                type: "int",
                nullable: false,
                defaultValue: 0,
                oldClrType: typeof(int),
                oldType: "int",
                oldNullable: true);

            migrationBuilder.AddColumn<DateOnly>(
                name: "PlannedDate",
                table: "StudySessions",
                type: "date",
                nullable: false,
                defaultValue: new DateOnly(1, 1, 1));

            migrationBuilder.AddColumn<TimeOnly>(
                name: "PlannedEndTime",
                table: "StudySessions",
                type: "time",
                nullable: false,
                defaultValue: new TimeOnly(0, 0, 0));

            migrationBuilder.AddColumn<TimeOnly>(
                name: "PlannedStartTime",
                table: "StudySessions",
                type: "time",
                nullable: false,
                defaultValue: new TimeOnly(0, 0, 0));

            migrationBuilder.AddColumn<int>(
                name: "SpacesRepititionSessionId",
                table: "StudySessions",
                type: "int",
                nullable: false,
                defaultValue: 0);

            migrationBuilder.AddColumn<byte>(
                name: "Status",
                table: "StudySessions",
                type: "tinyint",
                nullable: false,
                defaultValue: (byte)0);

            migrationBuilder.CreateTable(
                name: "SpacedRepetitionSessions",
                columns: table => new
                {
                    Id = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    RepetitionNumber = table.Column<int>(type: "int", nullable: false),
                    Score = table.Column<int>(type: "int", nullable: false),
                    LastReviewDate = table.Column<DateOnly>(type: "date", nullable: false),
                    UserId = table.Column<string>(type: "nvarchar(450)", nullable: false),
                    LessonId = table.Column<int>(type: "int", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_SpacedRepetitionSessions", x => x.Id);
                    table.ForeignKey(
                        name: "FK_SpacedRepetitionSessions_AspNetUsers_UserId",
                        column: x => x.UserId,
                        principalTable: "AspNetUsers",
                        principalColumn: "Id");
                    table.ForeignKey(
                        name: "FK_SpacedRepetitionSessions_Lessons_LessonId",
                        column: x => x.LessonId,
                        principalTable: "Lessons",
                        principalColumn: "LessonId");
                });

            migrationBuilder.CreateIndex(
                name: "IX_StudySessions_SpacesRepititionSessionId",
                table: "StudySessions",
                column: "SpacesRepititionSessionId");

            migrationBuilder.CreateIndex(
                name: "IX_SpacedRepetitionSessions_LessonId",
                table: "SpacedRepetitionSessions",
                column: "LessonId");

            migrationBuilder.CreateIndex(
                name: "IX_SpacedRepetitionSessions_UserId",
                table: "SpacedRepetitionSessions",
                column: "UserId");

            migrationBuilder.AddForeignKey(
                name: "FK_QuestionDetails_SpacedRepetitionSessions_SessionID",
                table: "QuestionDetails",
                column: "SessionID",
                principalTable: "SpacedRepetitionSessions",
                principalColumn: "Id",
                onDelete: ReferentialAction.Cascade);

            migrationBuilder.AddForeignKey(
                name: "FK_StudyPlans_SpacedRepetitionSessions_SpacedRepetitionSessionId",
                table: "StudyPlans",
                column: "SpacedRepetitionSessionId",
                principalTable: "SpacedRepetitionSessions",
                principalColumn: "Id",
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
                principalColumn: "LessonId",
                onDelete: ReferentialAction.Cascade);

            migrationBuilder.AddForeignKey(
                name: "FK_StudySessions_SpacedRepetitionSessions_SpacesRepititionSessionId",
                table: "StudySessions",
                column: "SpacesRepititionSessionId",
                principalTable: "SpacedRepetitionSessions",
                principalColumn: "Id",
                onDelete: ReferentialAction.Cascade);

            migrationBuilder.AddForeignKey(
                name: "FK_UserAddedQuestionDetails_SpacedRepetitionSessions_SessionID",
                table: "UserAddedQuestionDetails",
                column: "SessionID",
                principalTable: "SpacedRepetitionSessions",
                principalColumn: "Id",
                onDelete: ReferentialAction.Cascade);
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
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
                name: "FK_StudySessions_SpacedRepetitionSessions_SpacesRepititionSessionId",
                table: "StudySessions");

            migrationBuilder.DropForeignKey(
                name: "FK_UserAddedQuestionDetails_SpacedRepetitionSessions_SessionID",
                table: "UserAddedQuestionDetails");

            migrationBuilder.DropTable(
                name: "SpacedRepetitionSessions");

            migrationBuilder.DropIndex(
                name: "IX_StudySessions_SpacesRepititionSessionId",
                table: "StudySessions");

            migrationBuilder.DropColumn(
                name: "PlannedDate",
                table: "StudySessions");

            migrationBuilder.DropColumn(
                name: "PlannedEndTime",
                table: "StudySessions");

            migrationBuilder.DropColumn(
                name: "PlannedStartTime",
                table: "StudySessions");

            migrationBuilder.DropColumn(
                name: "SpacesRepititionSessionId",
                table: "StudySessions");

            migrationBuilder.DropColumn(
                name: "Status",
                table: "StudySessions");

            migrationBuilder.RenameColumn(
                name: "LessonId",
                table: "Lessons",
                newName: "LessonID");

            migrationBuilder.AlterColumn<int>(
                name: "Score",
                table: "StudySessions",
                type: "int",
                nullable: true,
                oldClrType: typeof(int),
                oldType: "int");

            migrationBuilder.AddColumn<string>(
                name: "Discriminator",
                table: "StudySessions",
                type: "nvarchar(34)",
                maxLength: 34,
                nullable: false,
                defaultValue: "");

            migrationBuilder.AddColumn<int>(
                name: "RepetitionNumber",
                table: "StudySessions",
                type: "int",
                nullable: true);

            migrationBuilder.AddForeignKey(
                name: "FK_QuestionDetails_StudySessions_SessionID",
                table: "QuestionDetails",
                column: "SessionID",
                principalTable: "StudySessions",
                principalColumn: "Id",
                onDelete: ReferentialAction.Cascade);

            migrationBuilder.AddForeignKey(
                name: "FK_StudyPlans_StudySessions_SpacedRepetitionSessionId",
                table: "StudyPlans",
                column: "SpacedRepetitionSessionId",
                principalTable: "StudySessions",
                principalColumn: "Id",
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
                principalColumn: "Id",
                onDelete: ReferentialAction.Cascade);
        }
    }
}
