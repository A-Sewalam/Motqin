export const Sidebar = () => {
  return (
    <aside
      className="
        w-72 p-4 hidden md:block
        bg-[var(--sidebar-bg)]
        text-[var(--sidebar-text)]
        border-r border-[var(--input-border)]
        transition-colors
      "
    >
      <h2 className="text-lg font-bold mb-4">Lesson Topics</h2>

      <ul className="space-y-2 text-md">
        <li className="p-2 rounded-lg bg-blue-100 text-blue-700 dark:bg-blue-600/20 dark:text-blue-300 cursor-pointer">
          Introduction
        </li>

        <li className="p-2 rounded-lg cursor-pointer hover:bg-[var(--sidebar-hover)] transition-colors">
          Key Concepts
        </li>

        <li className="p-2 rounded-lg cursor-pointer hover:bg-[var(--sidebar-hover)] transition-colors">
          Examples
        </li>

        <li className="p-2 rounded-lg cursor-pointer hover:bg-[var(--sidebar-hover)] transition-colors">
          Practice Questions
        </li>
      </ul>
    </aside>
  );
};
