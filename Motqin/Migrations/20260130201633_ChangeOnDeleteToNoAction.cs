using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace Motqin.Migrations
{
    /// <inheritdoc />
    public partial class ChangeOnDeleteToNoAction : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropForeignKey(
                name: "FK_CompetitionEntries_Competitions_CompetitionID",
                table: "CompetitionEntries");

            migrationBuilder.DropForeignKey(
                name: "FK_CompetitionEntries_Users_UserID",
                table: "CompetitionEntries");

            migrationBuilder.DropForeignKey(
                name: "FK_DistractionControls_Users_UserID",
                table: "DistractionControls");

            migrationBuilder.DropForeignKey(
                name: "FK_Lessons_Subjects_SubjectID",
                table: "Lessons");

            migrationBuilder.DropForeignKey(
                name: "FK_QuestionDetails_Questions_QuestionID",
                table: "QuestionDetails");

            migrationBuilder.DropForeignKey(
                name: "FK_QuestionDetails_StudySessions_SessionID",
                table: "QuestionDetails");

            migrationBuilder.DropForeignKey(
                name: "FK_Questions_Lessons_LessonID",
                table: "Questions");

            migrationBuilder.DropForeignKey(
                name: "FK_StudyPlans_Lessons_LessonID",
                table: "StudyPlans");

            migrationBuilder.DropForeignKey(
                name: "FK_StudyPlans_Users_UserID",
                table: "StudyPlans");

            migrationBuilder.DropForeignKey(
                name: "FK_StudySessions_Lessons_LessonID",
                table: "StudySessions");

            migrationBuilder.DropForeignKey(
                name: "FK_StudySessions_Users_UserID",
                table: "StudySessions");

            migrationBuilder.AddForeignKey(
                name: "FK_CompetitionEntries_Competitions_CompetitionID",
                table: "CompetitionEntries",
                column: "CompetitionID",
                principalTable: "Competitions",
                principalColumn: "CompetitionID");

            migrationBuilder.AddForeignKey(
                name: "FK_CompetitionEntries_Users_UserID",
                table: "CompetitionEntries",
                column: "UserID",
                principalTable: "Users",
                principalColumn: "UserId");

            migrationBuilder.AddForeignKey(
                name: "FK_DistractionControls_Users_UserID",
                table: "DistractionControls",
                column: "UserID",
                principalTable: "Users",
                principalColumn: "UserId");

            migrationBuilder.AddForeignKey(
                name: "FK_Lessons_Subjects_SubjectID",
                table: "Lessons",
                column: "SubjectID",
                principalTable: "Subjects",
                principalColumn: "SubjectID");

            migrationBuilder.AddForeignKey(
                name: "FK_QuestionDetails_Questions_QuestionID",
                table: "QuestionDetails",
                column: "QuestionID",
                principalTable: "Questions",
                principalColumn: "QuestionID");

            migrationBuilder.AddForeignKey(
                name: "FK_QuestionDetails_StudySessions_SessionID",
                table: "QuestionDetails",
                column: "SessionID",
                principalTable: "StudySessions",
                principalColumn: "SessionID");

            migrationBuilder.AddForeignKey(
                name: "FK_Questions_Lessons_LessonID",
                table: "Questions",
                column: "LessonID",
                principalTable: "Lessons",
                principalColumn: "LessonID");

            migrationBuilder.AddForeignKey(
                name: "FK_StudyPlans_Lessons_LessonID",
                table: "StudyPlans",
                column: "LessonID",
                principalTable: "Lessons",
                principalColumn: "LessonID");

            migrationBuilder.AddForeignKey(
                name: "FK_StudyPlans_Users_UserID",
                table: "StudyPlans",
                column: "UserID",
                principalTable: "Users",
                principalColumn: "UserId");

            migrationBuilder.AddForeignKey(
                name: "FK_StudySessions_Lessons_LessonID",
                table: "StudySessions",
                column: "LessonID",
                principalTable: "Lessons",
                principalColumn: "LessonID");

            migrationBuilder.AddForeignKey(
                name: "FK_StudySessions_Users_UserID",
                table: "StudySessions",
                column: "UserID",
                principalTable: "Users",
                principalColumn: "UserId");
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropForeignKey(
                name: "FK_CompetitionEntries_Competitions_CompetitionID",
                table: "CompetitionEntries");

            migrationBuilder.DropForeignKey(
                name: "FK_CompetitionEntries_Users_UserID",
                table: "CompetitionEntries");

            migrationBuilder.DropForeignKey(
                name: "FK_DistractionControls_Users_UserID",
                table: "DistractionControls");

            migrationBuilder.DropForeignKey(
                name: "FK_Lessons_Subjects_SubjectID",
                table: "Lessons");

            migrationBuilder.DropForeignKey(
                name: "FK_QuestionDetails_Questions_QuestionID",
                table: "QuestionDetails");

            migrationBuilder.DropForeignKey(
                name: "FK_QuestionDetails_StudySessions_SessionID",
                table: "QuestionDetails");

            migrationBuilder.DropForeignKey(
                name: "FK_Questions_Lessons_LessonID",
                table: "Questions");

            migrationBuilder.DropForeignKey(
                name: "FK_StudyPlans_Lessons_LessonID",
                table: "StudyPlans");

            migrationBuilder.DropForeignKey(
                name: "FK_StudyPlans_Users_UserID",
                table: "StudyPlans");

            migrationBuilder.DropForeignKey(
                name: "FK_StudySessions_Lessons_LessonID",
                table: "StudySessions");

            migrationBuilder.DropForeignKey(
                name: "FK_StudySessions_Users_UserID",
                table: "StudySessions");

            migrationBuilder.AddForeignKey(
                name: "FK_CompetitionEntries_Competitions_CompetitionID",
                table: "CompetitionEntries",
                column: "CompetitionID",
                principalTable: "Competitions",
                principalColumn: "CompetitionID",
                onDelete: ReferentialAction.Cascade);

            migrationBuilder.AddForeignKey(
                name: "FK_CompetitionEntries_Users_UserID",
                table: "CompetitionEntries",
                column: "UserID",
                principalTable: "Users",
                principalColumn: "UserId",
                onDelete: ReferentialAction.Cascade);

            migrationBuilder.AddForeignKey(
                name: "FK_DistractionControls_Users_UserID",
                table: "DistractionControls",
                column: "UserID",
                principalTable: "Users",
                principalColumn: "UserId",
                onDelete: ReferentialAction.Cascade);

            migrationBuilder.AddForeignKey(
                name: "FK_Lessons_Subjects_SubjectID",
                table: "Lessons",
                column: "SubjectID",
                principalTable: "Subjects",
                principalColumn: "SubjectID",
                onDelete: ReferentialAction.Cascade);

            migrationBuilder.AddForeignKey(
                name: "FK_QuestionDetails_Questions_QuestionID",
                table: "QuestionDetails",
                column: "QuestionID",
                principalTable: "Questions",
                principalColumn: "QuestionID",
                onDelete: ReferentialAction.Cascade);

            migrationBuilder.AddForeignKey(
                name: "FK_QuestionDetails_StudySessions_SessionID",
                table: "QuestionDetails",
                column: "SessionID",
                principalTable: "StudySessions",
                principalColumn: "SessionID",
                onDelete: ReferentialAction.Cascade);

            migrationBuilder.AddForeignKey(
                name: "FK_Questions_Lessons_LessonID",
                table: "Questions",
                column: "LessonID",
                principalTable: "Lessons",
                principalColumn: "LessonID",
                onDelete: ReferentialAction.Cascade);

            migrationBuilder.AddForeignKey(
                name: "FK_StudyPlans_Lessons_LessonID",
                table: "StudyPlans",
                column: "LessonID",
                principalTable: "Lessons",
                principalColumn: "LessonID",
                onDelete: ReferentialAction.Cascade);

            migrationBuilder.AddForeignKey(
                name: "FK_StudyPlans_Users_UserID",
                table: "StudyPlans",
                column: "UserID",
                principalTable: "Users",
                principalColumn: "UserId",
                onDelete: ReferentialAction.Cascade);

            migrationBuilder.AddForeignKey(
                name: "FK_StudySessions_Lessons_LessonID",
                table: "StudySessions",
                column: "LessonID",
                principalTable: "Lessons",
                principalColumn: "LessonID",
                onDelete: ReferentialAction.Cascade);

            migrationBuilder.AddForeignKey(
                name: "FK_StudySessions_Users_UserID",
                table: "StudySessions",
                column: "UserID",
                principalTable: "Users",
                principalColumn: "UserId",
                onDelete: ReferentialAction.Cascade);
        }
    }
}
