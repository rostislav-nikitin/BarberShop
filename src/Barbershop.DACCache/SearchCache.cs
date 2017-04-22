namespace Barbershop.DACCache
{

    using NReco.Data;

    using Barbershop.DAC;
    using System;

    public class SearchCache : IDataAccess
    {
        private static readonly Lazy<SearchCache> instance = new Lazy<SearchCache>(() => new SearchCache());

        private readonly CacheAccessor<string, RecordSet> _cache;

        private SearchCache()
        {
            _cache = new CacheAccessor<string, RecordSet>();
        }

        public static SearchCache Instance
        {
            get
            {
                return instance.Value;
            }
        }

        public RecordSet FindEmployee(string searchString)
        {
            RecordSet result = _cache.Get(searchString);
            if (result == null)
            {
                IDataAccess dataAccess = new DataAccess();
                result = dataAccess.FindEmployee(searchString);

                _cache.Add(searchString, result);
            }

            return result;
        }
    }
}
