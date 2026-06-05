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
            migrationBuilder.AddColumn<int>(
                name: "PrevSpacedRepetitionSessionId",
                table: "StudyPlans",
                type: "int",
                nullable: false,
                defaultValue: 0);

            migrationBuilder.CreateIndex(
                name: "IX_StudyPlans_PrevSpacedRepetitionSessionId",
                table: "StudyPlans",
                column: "PrevSpacedRepetitionSessionId");

            migrationBuilder.AddForeignKey(
                name: "FK_StudyPlans_SpacedRepetitionSessions_PrevSpacedRepetitionSessionId",
                table: "StudyPlans",
                column: "PrevSpacedRepetitionSessionId",
                principalTable: "SpacedRepetitionSessions",
                principalColumn: "SessionID",
                onDelete: ReferentialAction.Cascade);
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropForeignKey(
                name: "FK_StudyPlans_SpacedRepetitionSessions_PrevSpacedRepetitionSessionId",
                table: "StudyPlans");

            migrationBuilder.DropIndex(
                name: "IX_StudyPlans_PrevSpacedRepetitionSessionId",
                table: "StudyPlans");

            migrationBuilder.DropColumn(
                name: "PrevSpacedRepetitionSessionId",
                table: "StudyPlans");
        }
    }
}
