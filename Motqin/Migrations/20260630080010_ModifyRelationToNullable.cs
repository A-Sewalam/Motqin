using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace Motqin.Migrations
{
    /// <inheritdoc />
    public partial class ModifyRelationToNullable : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropForeignKey(
                name: "FK_StudySessions_SpacedRepetitionSessions_SpacesRepititionSessionId",
                table: "StudySessions");

            migrationBuilder.AlterColumn<int>(
                name: "SpacesRepititionSessionId",
                table: "StudySessions",
                type: "int",
                nullable: true,
                oldClrType: typeof(int),
                oldType: "int");

            migrationBuilder.AddForeignKey(
                name: "FK_StudySessions_SpacedRepetitionSessions_SpacesRepititionSessionId",
                table: "StudySessions",
                column: "SpacesRepititionSessionId",
                principalTable: "SpacedRepetitionSessions",
                principalColumn: "Id");
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropForeignKey(
                name: "FK_StudySessions_SpacedRepetitionSessions_SpacesRepititionSessionId",
                table: "StudySessions");

            migrationBuilder.AlterColumn<int>(
                name: "SpacesRepititionSessionId",
                table: "StudySessions",
                type: "int",
                nullable: false,
                defaultValue: 0,
                oldClrType: typeof(int),
                oldType: "int",
                oldNullable: true);

            migrationBuilder.AddForeignKey(
                name: "FK_StudySessions_SpacedRepetitionSessions_SpacesRepititionSessionId",
                table: "StudySessions",
                column: "SpacesRepititionSessionId",
                principalTable: "SpacedRepetitionSessions",
                principalColumn: "Id",
                onDelete: ReferentialAction.Cascade);
        }
    }
}
