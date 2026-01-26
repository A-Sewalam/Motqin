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
          description="Learn math step by step with clear explanations, solved examples, and practice questions — from basics to advanced problem solving."
          hours={3}
          state="continue"
          href="/Ai-Teacher"
        />
        <LessonCardClient
          title="Lesson 2"
          description="Understand how the universe works through laws, experiments, and real-life applications explained in a simple and intuitive way."
          hours={2}
          state="start"
          href="/Ai-Teacher"
        />
        <LessonCardClient
          title="Lesson 3"
          description="Explore chemical reactions, equations, and concepts with easy explanations, and exam-focused practice."
          hours={3}
          state="start"
          href="/Ai-Teacher"
        />
        <LessonCardClient
          title="Lesson 4"
          description="Learn about living organisms, human body systems, genetics, and ecosystems with clear explanations and diagrams."
          hours={2}
          state="start"
          href="/Ai-Teacher"
        />
        <LessonCardClient
          title="Lesson 5"
          description="Improve your English skills including grammar, vocabulary, reading, writing, and conversation with practical examples and exercises."
          hours={5}
          state="start"
          href="/Ai-Teacher"
        />
      </div>
    </div>
  );
};

export default SubjectPage;
