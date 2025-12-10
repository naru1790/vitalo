-- 1. Create a minimal 'profiles' table
create table public.profiles (
  id uuid references auth.users not null primary key, -- Connects to Supabase Auth
  email text,
  full_name text,
  created_at timestamp with time zone default timezone('utc'::text, now()),
  updated_at timestamp with time zone default timezone('utc'::text, now())
);

-- 2. Enable Security (RLS)
alter table public.profiles enable row level security;

-- Policy: Everyone can read profiles (useful for future features)
create policy "Public profiles are viewable by everyone."
  on profiles for select
  using ( true );

-- Policy: Only the user can edit their OWN profile
create policy "Users can update own profile."
  on profiles for update
  using ( auth.uid() = id );

-- 3. The Automation (Trigger)
-- Automatically creates a profile row when a user signs up
create or replace function public.handle_new_user()
returns trigger
language plpgsql
security definer set search_path = public
as $$
begin
  insert into public.profiles (id, email, full_name)
  values (
    new.id, 
    new.email, 
    new.raw_user_meta_data ->> 'full_name' -- Captures the name from Flutter
  );
  return new;
end;
$$;

-- 4. Activate the Trigger
create trigger on_auth_user_created
  after insert on auth.users
  for each row execute procedure public.handle_new_user();