namespace Motqin.Dtos.Planner
{
    public record PlannerResponse
    (
        List<StudySessionDto> sessions,
        string OptimizationReasoning
    );
}
