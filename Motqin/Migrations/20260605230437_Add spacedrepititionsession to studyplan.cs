using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace Motqin.Migrations
{
    /// <inheritdoc />
    public partial class Addspacedrepititionsessiontostudyplan : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.RenameColumn(
                name: "RepetitionNumber",
                table: "StudyPlans",
                newName: "SpacedRepetitionSessionId");

            migrationBuilder.CreateIndex(
                name: "IX_StudyPlans_SpacedRepetitionSessionId",
                table: "StudyPlans",
                column: "SpacedRepetitionSessionId");

            migrationBuilder.AddForeignKey(
                name: "FK_StudyPlans_SpacedRepetitionSessions_SpacedRepetitionSessionId",
                table: "StudyPlans",
                column: "SpacedRepetitionSessionId",
                principalTable: "SpacedRepetitionSessions",
                principalColumn: "SessionID",
                onDelete: ReferentialAction.Cascade);
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropForeignKey(
                name: "FK_StudyPlans_SpacedRepetitionSessions_SpacedRepetitionSessionId",
                table: "StudyPlans");

            migrationBuilder.DropIndex(
                name: "IX_StudyPlans_SpacedRepetitionSessionId",
                table: "StudyPlans");

            migrationBuilder.RenameColumn(
                name: "SpacedRepetitionSessionId",
                table: "StudyPlans",
                newName: "RepetitionNumber");
        }
    }
}
