using Motqin.Data;
using Motqin.Models;

namespace Motqin.Services
{
    public interface IPlanService
    {
        StudyPlan? GetById(int id);
        void SetNextReviewDate(StudyPlan plan);
    }

    public class PlanService : IPlanService
    {
        private readonly AppDbContext context;

        public PlanService(AppDbContext context)
        {
            this.context = context;
        }
        public StudyPlan? GetById(int id) => context.StudyPlans.Find(id);
        public void SetNextReviewDate(StudyPlan plan)
        {
            switch (plan.RepetitionNumber)
            {
                case 1:
                    plan.NextReviewDate.AddDays(1);
                    break;
                case 2:
                    plan.NextReviewDate.AddDays(5);
                    break;
                case 3:
                    plan.NextReviewDate.AddDays(7);
                    break;
                case 4:
                    plan.NextReviewDate.AddDays(10);
                    break;
            }
        }
    }
}
