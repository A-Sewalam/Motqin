import { LessonCardClient } from "@/components/LessonCard.client";

interface SubjectPageProps {
  params: Promise<{
    subjectId: string;
  }>;
}

const SubjectPage = async ({ params }: SubjectPageProps) => {
  const { subjectId } = await params;

  return (
    <div className="bg-zinc-100 min-h-screen flex-col gap-6 px-10">
      <div className="p-10">
        <h1 className="text-3xl text-blue-950 font-bold capitalize ">{subjectId}</h1>
      </div>
      <div className="flex-col gap-20 m-5 px-7">
        <LessonCardClient
          title="Lesson 1"
          description="Algebra, calculus, and problem solving"
          hours={18}
          state="continue"
          href="/subjects/math"
        />
      </div>
    </div>
  );
};

export default SubjectPage;
