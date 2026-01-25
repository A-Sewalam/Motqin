export const Sidebar = () => {
    return (
      <aside className="w-72 bg-white border-r border-zinc-200 p-4 hidden md:block">
        <h2 className="text-lg font-bold text-zinc-900 mb-4">
          Lesson Topics
        </h2>
  
        <ul className="space-y-2 text-md text-blue-900">
          <li className="p-2 rounded-lg bg-blue-100 text-blue-700 cursor-pointer">
            Introduction
          </li>
          <li className="p-2 rounded-lg hover:bg-zinc-100 cursor-pointer">
            Key Concepts
          </li>
          <li className="p-2 rounded-lg hover:bg-zinc-100 cursor-pointer">
            Examples
          </li>
          <li className="p-2 rounded-lg hover:bg-zinc-100 cursor-pointer">
            Practice Questions
          </li>
        </ul>
      </aside>
    );
  };
  