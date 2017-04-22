namespace Barbershop.DACCache
{
    using System.Collections.Concurrent;
    using System.Collections.Generic;

    public class Cache<TKey, TValue>
    {
        private IDictionary<TKey, TValue> _cache;

        public Cache()
        {
            _cache = new ConcurrentDictionary<TKey, TValue>();
        }

        public void Add(TKey key, TValue value)
        {
            _cache[key] = value;
        }

        public TValue Get(TKey key)
        {
            TValue result;

            if (_cache.ContainsKey(key))
            {
                result = _cache[key];
            }
            else
            {
                result = default(TValue);
            }

            return result;
        }

        public void Remove(TKey key)
        {
            _cache.Remove(key);
        }

        public void Clear()
        {
            _cache.Clear();
        }
    }
}