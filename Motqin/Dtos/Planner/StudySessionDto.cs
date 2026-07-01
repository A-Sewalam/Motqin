namespace Motqin.Dtos.Planner
{
    public record StudySessionDto
    (
        string UserID,
        DateTime PlannedStart,
        DateTime PlannedEnd,
        int? SpacesRepititionSessionId
    );
}
