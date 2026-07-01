namespace Motqin.Dtos.Api
{
    public class ErrorResponse
    {
        public string Code { get; set; } = "error";
        public string Message { get; set; } = string.Empty;
    }
}
