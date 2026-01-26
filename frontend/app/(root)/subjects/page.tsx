import { SubjectCardClient } from "@/components/SubjectCard.client";
const SubjectsPage = () => {
  return (
    <div className="bg-zinc-100 min-h-screen flex-col gap-6 px-10">
      <div className="p-10">
        <h1 className="text-3xl text-blue-950 font-bold ">
          Available Subjects
        </h1>
      </div>
      <div className="flex-col gap-20 m-5 px-7">
        <SubjectCardClient
          title="Mathematics"
          // description="Algebra, calculus, and problem solving"
          lessons={24}
          hours={18}
          href="/subjects/math"
          className="my-2"
        />
        <SubjectCardClient
          title="Physics"
          // description="Mechanics, waves, and thermodynamics"
          lessons={16}
          hours={12}
          href="/subjects/physics"
        />
        <SubjectCardClient
          title="English"
          // description="Mechanics, waves, and thermodynamics"
          lessons={12}
          hours={7}
          href="/subjects/physics"
        />
        <SubjectCardClient
          title="Arabic"
          // description="Mechanics, waves, and thermodynamics"
          lessons={22}
          hours={30}
          href="/subjects/physics"
        />
        <SubjectCardClient
          title="Chemistry"
          // description="Mechanics, waves, and thermodynamics"
          lessons={17}
          hours={22}
          href="/subjects/physics"
        />
      </div>
    </div>
  );
};

export default SubjectsPage;
