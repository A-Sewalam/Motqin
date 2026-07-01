namespace Motqin.Dtos.Api
{
    public class ApiException
    {
        public ApiException(bool success, string message, string? details = null)
        {
            Success = success;
            Message = message;
            Details = details;
        }

        public bool Success { get; set; }
        public string Message { get; set; }
        public string? Details { get; set; }
    }
}
