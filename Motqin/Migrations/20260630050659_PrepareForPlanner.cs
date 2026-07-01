using System;
using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace Motqin.Migrations
{
    /// <inheritdoc />
    public partial class PrepareForPlanner : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropForeignKey(
                name: "FK_QuestionDetails_StudySessions_SessionID",
                table: "QuestionDetails");

            migrationBuilder.DropForeignKey(
                name: "FK_StudySessions_Lessons_SubjectID",
                table: "StudySessions");

            migrationBuilder.DropIndex(
                name: "IX_StudySessions_SubjectID",
                table: "StudySessions");

            migrationBuilder.DropColumn(
                name: "QuestionsCategory",
                table: "StudySessions");

            migrationBuilder.DropColumn(
                name: "StudySessionStatuses",
                table: "StudySessions");

            migrationBuilder.DropColumn(
                name: "SubjectID",
                table: "StudySessions");

            migrationBuilder.RenameColumn(
                name: "SessionID",
                table: "StudySessions",
                newName: "Id");

            migrationBuilder.AlterColumn<int>(
                name: "Days",
                table: "UserFreeTimes",
                type: "int",
                nullable: false,
                oldClrType: typeof(byte),
                oldType: "tinyint");

            migrationBuilder.AddColumn<DateOnly>(
                name: "ExamDate",
                table: "Subjects",
                type: "date",
                nullable: false,
                defaultValue: new DateOnly(1, 1, 1));

            migrationBuilder.AlterColumn<TimeOnly>(
                name: "StartTime",
                table: "StudySessions",
                type: "time",
                nullable: false,
                oldClrType: typeof(DateTime),
                oldType: "datetime2");

            migrationBuilder.AlterColumn<TimeOnly>(
                name: "EndTime",
                table: "StudySessions",
                type: "time",
                nullable: false,
                defaultValue: new TimeOnly(0, 0, 0),
                oldClrType: typeof(DateTime),
                oldType: "datetime2",
                oldNullable: true);

            migrationBuilder.AddColumn<DateOnly>(
                name: "Date",
                table: "StudySessions",
                type: "date",
                nullable: false,
                defaultValue: new DateOnly(1, 1, 1));

            migrationBuilder.AddColumn<int>(
                name: "Difficulty",
                table: "Lessons",
                type: "int",
                nullable: false,
                defaultValue: 0);

            migrationBuilder.AddColumn<int>(
                name: "EstimatedDuration",
                table: "Lessons",
                type: "int",
                nullable: true);

            migrationBuilder.AddForeignKey(
                name: "FK_QuestionDetails_StudySessions_SessionID",
                table: "QuestionDetails",
                column: "SessionID",
                principalTable: "StudySessions",
                principalColumn: "Id",
                onDelete: ReferentialAction.Cascade);
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropForeignKey(
                name: "FK_QuestionDetails_StudySessions_SessionID",
                table: "QuestionDetails");

            migrationBuilder.DropColumn(
                name: "ExamDate",
                table: "Subjects");

            migrationBuilder.DropColumn(
                name: "Date",
                table: "StudySessions");

            migrationBuilder.DropColumn(
                name: "Difficulty",
                table: "Lessons");

            migrationBuilder.DropColumn(
                name: "EstimatedDuration",
                table: "Lessons");

            migrationBuilder.RenameColumn(
                name: "Id",
                table: "StudySessions",
                newName: "SessionID");

            migrationBuilder.AlterColumn<byte>(
                name: "Days",
                table: "UserFreeTimes",
                type: "tinyint",
                nullable: false,
                oldClrType: typeof(int),
                oldType: "int");

            migrationBuilder.AlterColumn<DateTime>(
                name: "StartTime",
                table: "StudySessions",
                type: "datetime2",
                nullable: false,
                oldClrType: typeof(TimeOnly),
                oldType: "time");

            migrationBuilder.AlterColumn<DateTime>(
                name: "EndTime",
                table: "StudySessions",
                type: "datetime2",
                nullable: true,
                oldClrType: typeof(TimeOnly),
                oldType: "time");

            migrationBuilder.AddColumn<string>(
                name: "QuestionsCategory",
                table: "StudySessions",
                type: "nvarchar(max)",
                nullable: true);

            migrationBuilder.AddColumn<byte>(
                name: "StudySessionStatuses",
                table: "StudySessions",
                type: "tinyint",
                nullable: true);

            migrationBuilder.AddColumn<int>(
                name: "SubjectID",
                table: "StudySessions",
                type: "int",
                nullable: false,
                defaultValue: 0);

            migrationBuilder.CreateIndex(
                name: "IX_StudySessions_SubjectID",
                table: "StudySessions",
                column: "SubjectID");

            migrationBuilder.AddForeignKey(
                name: "FK_QuestionDetails_StudySessions_SessionID",
                table: "QuestionDetails",
                column: "SessionID",
                principalTable: "StudySessions",
                principalColumn: "SessionID");

            migrationBuilder.AddForeignKey(
                name: "FK_StudySessions_Lessons_SubjectID",
                table: "StudySessions",
                column: "SubjectID",
                principalTable: "Lessons",
                principalColumn: "LessonID",
                onDelete: ReferentialAction.Cascade);
        }
    }
}
