namespace OrleansOnAppService.Abstractions
{
    [GenerateSerializer]
    public class Visitor
    {

        [Id(0)]
        public string SessionKey { get; set; } = string.Empty;
        [Id(1)]
        public string RemoteAddress { get; set; } = string.Empty;
        [Id(2)]
        public string CurrentPage { get; set; } = string.Empty;
        [Id(3)]
        public DateTime Arrived { get; set; } = DateTime.Now;
        [Id(4)]
        public DateTime LastSeen { get; set; } = DateTime.Now;
    }
}
