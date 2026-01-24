using Microsoft.EntityFrameworkCore;
using Motqin.Data;

namespace Motqin
{
    public class Program
    {
        public static void Main(string[] args)
        {
            var builder = WebApplication.CreateBuilder(args);

            // Add services to the container.

            builder.Services.AddControllers();
            // Learn more about configuring Swagger/OpenAPI at https://aka.ms/aspnetcore/swashbuckle
            builder.Services.AddEndpointsApiExplorer();
            builder.Services.AddSwaggerGen();

            //Configure DBContext with SQL
            var connectionString = builder.Configuration.GetConnectionString("DefaultConnectionString");
            builder.Services.AddDbContext<AppDbContext>(options => options.UseSqlServer(connectionString));
            builder.Services.AddScoped<Services.IUsersService, Services.UsersService>();
            builder.Services.AddScoped<Services.ILessonsService, Services.LessonsService>();
            builder.Services.AddScoped<Services.SubjectsService>();
            builder.Services.AddScoped<Services.QuestionsService>();

            var app = builder.Build();

            //Seeding after build
            AppDbInitializer.Seed(app);

            // Configure the HTTP request pipeline.
            if (app.Environment.IsDevelopment())
            {
                app.UseSwagger();
                app.UseSwaggerUI();
            }

            app.UseHttpsRedirection();

            app.UseAuthorization();


            app.MapControllers();

            app.Run();
        }
    }
}
