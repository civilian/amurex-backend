create extension if not exists vector;

create table meetings (
  id serial primary key,
  user_id uuid not null references auth.users(id),
  meeting_id text not null,
  transcript text,
  context_files text,
  created_at timestamp with time zone default timezone('utc'::text, now()),
  updated_at timestamp with time zone default timezone('utc'::text, now()),
  embeddings vector(1536), -- Define the dimension of the vector
  generated_prompt jsonb,
  chunks text,
  suggestion_count int2 default '0'::smallint
);

-- Add a constraint name for the foreign key if it doesn't exist
do $$
begin
    if not exists (
        select 1
        from pg_constraint
        where conname = 'meetings_user_id_fkey'
    ) then
        alter table meetings add constraint meetings_user_id_fkey 
        foreign key (user_id) references auth.users(id);
    end if;
end $$;